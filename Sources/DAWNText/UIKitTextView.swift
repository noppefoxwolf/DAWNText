import UIKit
import os

public final class UIKitTextView: UITextView {
    var extraActions: [UIAction] = []
    var selectionMode: SelectionMode = .all

    // workaround: When use init(usingTextLayoutManager:), property always return false.
    // Computed property is OK.
    // https://twitter.com/noppefoxwolf/status/1703757738181009679?s=61&t=Yf_LbVTz6v_wxN-QEb77XA
    var usesAllTextLayoutFragmentSize: Bool { true }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let textLayoutManager = NSTextLayoutManager()
        textLayoutManager.layoutQueue = .main

        if let usesFontLeading = self.textLayoutManager?.usesFontLeading {
            textLayoutManager.usesFontLeading = usesFontLeading
        }
        if let limitsLayoutForSuspiciousContents = self.textLayoutManager?
            .limitsLayoutForSuspiciousContents
        {
            textLayoutManager.limitsLayoutForSuspiciousContents = limitsLayoutForSuspiciousContents
        }
        if let usesHyphenation = self.textLayoutManager?.usesHyphenation {
            textLayoutManager.usesHyphenation = usesHyphenation
        }
        let textContainer = NSTextContainer()

        textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding
        textContainer.maximumNumberOfLines = self.textContainer.maximumNumberOfLines
        textContainer.lineBreakMode = self.textContainer.lineBreakMode

        textLayoutManager.textContainer = textContainer
        let textContentStorage = NSTextContentStorage()
        textContentStorage.addTextLayoutManager(textLayoutManager)
        textContentStorage.textStorage!.setAttributedString(attributedText)

        textContainer.size.width = size.width
        textContainer.size.height = .zero

        var height: CGFloat = 0
        var maxWidth: CGFloat = 0

        if usesAllTextLayoutFragmentSize {
            textLayoutManager.enumerateTextLayoutFragments(
                from: nil,
                options: [.ensuresLayout],
                using: { textLayoutFragment in
                    maxWidth = max(textLayoutFragment.layoutFragmentFrame.width, maxWidth)
                    height = textLayoutFragment.layoutFragmentFrame.maxY
                    return true
                }
            )
            var newSize = size
            newSize.height = ceil(height)
            newSize.width = ceil(maxWidth)
            return newSize
        } else {
            textLayoutManager.enumerateTextLayoutFragments(
                from: textLayoutManager.documentRange.endLocation,
                options: [.reverse, .ensuresLayout]
            ) { layoutFragment in
                var maxY = layoutFragment.layoutFragmentFrame.maxY
                if maxY.isNaN {
                    maxY = 0
                }
                height = maxY
                var width = layoutFragment.layoutFragmentFrame.width
                if width.isNaN {
                    width = 0
                }
                maxWidth = width
                return false
            }
            var newSize = size
            newSize.height = ceil(height)
            if textContainer.maximumNumberOfLines == 1 {
                newSize.width = ceil(maxWidth)
            }
            return newSize
        }
    }

    public override func editMenu(for textRange: UITextRange, suggestedActions: [UIMenuElement])
        -> UIMenu?
    {
        var actions = suggestedActions

        if !textRange.isEmpty {
            let customMenu = UIMenu(options: .displayInline, children: extraActions)
            actions.append(customMenu)
        }

        return UIMenu(children: actions)
    }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        switch selectionMode {
        case .all:
            return super.point(inside: point, with: event)
        case .linkOnly:
            // リンク以外のタップを無効
            guard let position = closestPosition(to: point) else {
                return false
            }
            guard
                let range = tokenizer.rangeEnclosingPosition(
                    position,
                    with: .character,
                    inDirection: .layout(.left)
                )
            else {
                return false
            }
            let startIndex = offset(from: beginningOfDocument, to: range.start)
            return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
        case .none:
            return false
        }
    }
}
