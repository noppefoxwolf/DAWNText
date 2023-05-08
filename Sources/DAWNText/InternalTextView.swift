import SwiftUI
import Foundation
import UIKit

struct InternalTextView: UIViewRepresentable {
    init(
        attributedString: AttributedString
    ) {
        self.attributedString = attributedString
    }

    let attributedString: AttributedString

    @Environment(\.extraActions)
    var extraActions

    @Environment(\.selectionMode)
    var selectionMode

    @Environment(\.uiFont)
    var font

    @Environment(\.openURL)
    var openURLAction

    @Environment(\.lineLimit)
    var lineLimit

    @Environment(\.lineBreakMode)
    var lineBreakMode

    @Environment(\.lineFragmentPadding)
    var lineFragmentPadding

    @Environment(\.uiforegroundColor)
    var uiforegroundColor

    @Environment(\.textAlignment)
    var textAlignment

    func makeUIView(context: Context) -> UIKitTextView {
        let textView = UIKitTextView(usingTextLayoutManager: true)
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.contentInset = .zero
        textView.allowsEditingTextAttributes = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        textView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ textView: UIKitTextView, context: Context) {
        textView.extraActions = extraActions

        var attributedString = attributedString
        attributedString.foregroundColor = uiforegroundColor ?? .label
        attributedString.font = font ?? .preferredFont(forTextStyle: .body)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        attributedString.paragraphStyle = paragraphStyle
        textView.attributedText = NSAttributedString(attributedString)
        textView.textLayoutManager?.textContainer?.maximumNumberOfLines = lineLimit ?? 0
        textView.textLayoutManager?.textContainer?.lineBreakMode = lineBreakMode ?? .byWordWrapping
        textView.textLayoutManager?.textContainer?.lineFragmentPadding = lineFragmentPadding ?? 0
        textView.selectionMode = selectionMode
        textView.isSelectable = selectionMode != .none
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIKitTextView, context: Context)
        -> CGSize?
    {
        guard let width = proposal.width else { return nil }
        // guard zero, infinity and Nan
        guard width.isNormal else { return nil }

        // workaround: Layout側でキャッシュしてもsizeThatFitsが呼ばれるのでCoordinatorで設定する
        let cacheKey = Coordinator.CacheKey(
            width: width,
            attributedString: attributedString
        )
        if let size = context.coordinator.cache[cacheKey] {
            return size
        } else {
            let proposalSize = CGSize(width: proposal.width ?? 0, height: 0)
            let size = uiView.sizeThatFits(proposalSize)
            context.coordinator.cache[cacheKey] = size
            return size
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {

        let openURLAction: OpenURLAction

        struct CacheKey: Hashable {
            let width: Double
            let attributedString: AttributedString
        }
        var cache: [CacheKey: CGSize] = [:]

        init(_ base: InternalTextView) {
            self.openURLAction = base.openURLAction
            super.init()
        }

        // https://stackoverflow.com/a/4338011/1131587
        func textView(
            _ textView: UITextView,
            shouldInteractWith URL: URL,
            in characterRange: NSRange,
            interaction: UITextItemInteraction
        ) -> Bool {
            switch interaction {
            case .invokeDefaultAction:
                openURLAction(URL)
                return false
            case .presentActions, .preview:
                return true
            @unknown default:
                return true
            }
        }
    }
}
