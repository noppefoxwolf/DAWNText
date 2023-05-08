import UIKit

final class UIKitTextView: UITextView {
    var extraActions: [UIAction] = []
    var selectionMode: SelectionMode = .all

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let textLayoutManager = NSTextLayoutManager()
        if let usesFontLeading = self.textLayoutManager?.usesFontLeading {
            textLayoutManager.usesFontLeading = usesFontLeading
        }
        if let usesHyphenation = self.textLayoutManager?.usesHyphenation {
            textLayoutManager.usesHyphenation = usesHyphenation
        }
        let textContainer = NSTextContainer(size: size)
        if let lineFragmentPadding = self.textLayoutManager?.textContainer?.lineFragmentPadding {
            textContainer.lineFragmentPadding = lineFragmentPadding
        }
        if let maximumNumberOfLines = self.textLayoutManager?.textContainer?.maximumNumberOfLines {
            textContainer.maximumNumberOfLines = maximumNumberOfLines
        }
        if let lineBreakMode = self.textLayoutManager?.textContainer?.lineBreakMode {
            textContainer.lineBreakMode = lineBreakMode
        }
        textLayoutManager.textContainer = textContainer
        let textContentStorage = NSTextContentStorage()
        textContentStorage.attributedString = attributedText
        textContentStorage.addTextLayoutManager(textLayoutManager)

        // TextKit2を使って計算することでめり込みがなくなる
        // https://developer.apple.com/documentation/appkit/textkit/using_textkit_2_to_interact_with_text
        var maxWidth: Double = 0
        var height: Double = 0
        // 終行だけ取っても間のレイアウトが終わってないと変な値がくるので全部見る
        textLayoutManager.enumerateTextLayoutFragments(
            from: nil,
            options: [.ensuresLayout],
            using: { textLayoutFragment in
                maxWidth = max(textLayoutFragment.layoutFragmentFrame.width, maxWidth)
                height = textLayoutFragment.layoutFragmentFrame.maxY
                return true
            }
        )

        return CGSize(width: ceil(maxWidth), height: ceil(height))
    }

    override func editMenu(for textRange: UITextRange, suggestedActions: [UIMenuElement])
        -> UIMenu?
    {
        var actions = suggestedActions

        if !textRange.isEmpty {
            let customMenu = UIMenu(options: .displayInline, children: extraActions)
            actions.append(customMenu)
        }

        return UIMenu(children: actions)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
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
