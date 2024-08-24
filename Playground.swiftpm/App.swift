import SwiftUI
import DAWNText

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    TextView("Hello, World!!")
                    TextView("in List")
                    VStack {
                        TextView("Hello, World!!")
                        TextView("in VStack")
                    }
                    HStack {
                        TextView("Hello, World!!")
                        TextView("in HStack")
                    }
                    
                    TextView(attributedString)
                    
                    TextView(nsAttributedString)
                }.navigationTitle("DAWNText")
            }
        }
    }
    
    var attributedString: AttributedString {
        try! AttributedString(
            markdown: """
            **Markdown** is *easy* syntax.
            [Link to Apple](https://apple.com)
            """,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )
    }
    
    var nsAttributedString: AttributedString {
        let attachment = NSTextAttachment(image: .actions)
        let nsAttributedString = NSMutableAttributedString(attachment: attachment)
        nsAttributedString.append(NSAttributedString("is image."))
        return AttributedString(nsAttributedString)
    }
}
