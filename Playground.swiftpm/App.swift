import SwiftUI
import DAWNText

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
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
            }
        }
    }
    
    var attributedString: AttributedString {
        try! AttributedString(
            markdown: """
            **Markdown** is *easy* syntax.
            """
        )
    }
    
    var nsAttributedString: AttributedString {
        let attachment = NSTextAttachment(image: .actions)
        let nsAttributedString = NSMutableAttributedString(attachment: attachment)
        nsAttributedString.append(NSAttributedString("is image."))
        return AttributedString(nsAttributedString)
    }
}
