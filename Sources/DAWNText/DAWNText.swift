import SwiftUI

public enum DAWN {}

public extension DAWN {
    struct Text: View {
        public init(
            _ attributedString: AttributedString
        ) {
            self.attributedString = attributedString
        }
        
        public init(
            _ content: any StringProtocol
        ) {
            self.attributedString = AttributedString(content)
        }

        let attributedString: AttributedString

        public var body: some View {
            // workaround: 横幅を取得するためにsizeThatFitsでくくる
            ViewThatFits(in: .horizontal) {
                InternalTextView(
                    attributedString: attributedString
                )
            }
        }
    }
}
