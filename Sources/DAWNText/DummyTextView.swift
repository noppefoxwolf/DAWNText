import UIKit
import os

public final class DummyTextView: UIView {
    var extraActions: [UIAction] = []
    var selectionMode: SelectionMode = .all
    var textContainerInset: UIEdgeInsets = .zero
    var contentInset: UIEdgeInsets = .zero
    var allowsEditingTextAttributes: Bool = false
    var isEditable: Bool = false
    var isSelectable: Bool = false
    var isScrollEnabled: Bool = false
    var showsVerticalScrollIndicator: Bool = false
    var showsHorizontalScrollIndicator: Bool = false
    var attributedText: NSAttributedString = .init()
    var textLayoutManager: NSTextLayoutManager? = nil
    weak var delegate: (any UITextViewDelegate)? = nil

    init(usingTextLayoutManager: Bool) {
        super.init(frame: .null)
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let textLayoutManager = NSTextLayoutManager()
        textLayoutManager.layoutQueue = .main

        if let usesFontLeading = self.textLayoutManager?.usesFontLeading {
            textLayoutManager.usesFontLeading = usesFontLeading
        }
        if let usesHyphenation = self.textLayoutManager?.usesHyphenation {
            textLayoutManager.usesHyphenation = usesHyphenation
        }
        let textContainer = NSTextContainer()

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
        textContentStorage.addTextLayoutManager(textLayoutManager)
        textContentStorage.textStorage!.setAttributedString(attributedText)

        textContainer.size.width = size.width
        textContainer.size.height = .zero

        var height: CGFloat = 0
        var maxWidth: CGFloat = 0
        textLayoutManager.enumerateTextLayoutFragments(
            from: textLayoutManager.documentRange.endLocation,
            options: [.reverse, .ensuresLayout]
        ) { layoutFragment in
            height = layoutFragment.layoutFragmentFrame.maxY
            maxWidth = layoutFragment.layoutFragmentFrame.width
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
