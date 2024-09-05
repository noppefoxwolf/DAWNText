import SwiftUI
import UIKit

extension NSParagraphStyle: @unchecked Sendable {}

public struct TextView: View {
    public init(
        _ attributedString: AttributedString
    ) {
        self.attributedString = attributedString
    }

    let attributedString: AttributedString

    @Environment(\.uiFont)
    var uiFont

    public var body: some View {
        // workaround: 横幅を取得するためにsizeThatFitsでくくる
        ViewThatFits(in: .horizontal) {
            InternalTextView(
                attributedString: attributedString
            )
        }
    }
}

struct InternalTextView: UIViewRepresentable {
    init(
        attributedString: AttributedString
    ) {
        self.attributedString = attributedString
    }

    let attributedString: AttributedString

    typealias UIViewType = UIKitTextView
    //    typealias UIViewType = DummyTextView

    func makeUIView(context: Context) -> UIViewType {
        // updateは頻繁に呼ばれたりするので
        let textView = UIViewType(usingTextLayoutManager: true)
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.contentInset = .zero
        textView.allowsEditingTextAttributes = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        textView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.delegate = context.coordinator

        // https://twitter.com/noppefoxwolf/status/1672849798632976384?s=61&t=cwsZFMcBypoSq1n2DhTXeQ
        context.coordinator.openURLAction = context.environment.openURL
        context.coordinator.textItemTagAction = context.environment.onTapTextItemTagAction
        return textView
    }

    func updateUIView(_ textView: UIViewType, context: Context) {
        //        logger.info("\(#function) \(attributedString.description.prefix(10))")
        textView.extraActions = context.environment.extraActions

        var attributedString = attributedString
        attributedString.font = context.environment.uiFont
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .init(context.environment.multilineTextAlignment)
        attributedString.paragraphStyle = paragraphStyle
        // FIXME: NSAttributedStringの生成が重い
        textView.attributedText = try! NSAttributedString(
            attributedString,
            including: \.uiKit
        )
        textView.textLayoutManager?.textContainer?.maximumNumberOfLines =
            context.environment.lineLimit ?? 0
        textView.textLayoutManager?.textContainer?.lineBreakMode =
            context.environment.lineBreakMode ?? .byWordWrapping
        textView.textLayoutManager?.textContainer?.lineFragmentPadding =
            context.environment.lineFragmentPadding ?? 0
        textView.selectionMode = context.environment.selectionMode
        textView.isSelectable = context.environment.selectionMode != .none
        textView.onCopy = context.environment.onCppy.map { action in
            { action(AttributedString($0)) }
        }
        

        if context.environment.selectionMode != .all {
            // Lightweight hack
            for subview in textView.subviews {
                if "\(type(of: subview))" != "_UITextContainerView" {
                    subview.removeFromSuperview()
                }
            }
            for gestureRecognizer in textView.gestureRecognizers ?? [] {
                if gestureRecognizer.name != "UITextInteractionNameLinkTap" {
                    textView.removeGestureRecognizer(gestureRecognizer)
                }
            }
        }
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context)
        -> CGSize?
    {
        // guard zero, infinity and Nan
        guard let width = proposal.width, width.isNormal else { return nil }
        // workaround: Layout側でキャッシュしてもsizeThatFitsが呼ばれるのでCoordinatorで設定する
        let cacheKey = TextViewSizeCacheKey(
            width: width,
            attributedStringHashValue: attributedString.hashValue,
            fontHashValue: context.environment.uiFont.hashValue
        )
        if let size = context.environment.textViewSizeCache[cacheKey] {
            return size
        } else {
            let proposalSize = CGSize(width: proposal.width ?? 0, height: 0)
            let size = uiView.sizeThatFits(proposalSize)
            context.environment.textViewSizeCache[cacheKey] = size
            return size
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var openURLAction: OpenURLAction? = nil
        var textItemTagAction: OnTapTextItemTagAction? = nil

        func textView(
            _ textView: UITextView,
            primaryActionFor textItem: UITextItem,
            defaultAction: UIAction
        ) -> UIAction? {
            switch textItem.content {
            case .link(let url):
                return openURLAction.map({ action in
                    UIAction(handler: { _ in action(url) })
                })
            case .textAttachment:
                return nil
            case .tag(let textItemTag):
                return textItemTagAction.map { action in
                    UIAction(handler: { _ in action(textItemTag) })
                }
            @unknown default:
                return nil
            }
        }
    }
}
