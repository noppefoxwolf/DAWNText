import SwiftUI
import DAWNText

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    DAWN.Text("Hello, World!!")
                    DAWN.Text("in List")
                    VStack {
                        DAWN.Text("Hello, World!!")
                        DAWN.Text("in VStack")
                    }
                    HStack {
                        DAWN.Text("Hello, World!!")
                        DAWN.Text("in HStack")
                    }
                    
                    DAWN.Text(attributedString)
                    
                    DAWN.Text(nsAttributedString)
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
