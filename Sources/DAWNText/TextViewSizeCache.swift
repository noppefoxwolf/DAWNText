import Foundation
import SwiftUI

public struct TextViewSizeCacheKey: Hashable {
    let width: Double
    let attributedStringHashValue: Int
    let fontHashValue: Int
}

public typealias TextViewSizeCache = AnyCache<TextViewSizeCacheKey, CGSize>

extension EnvironmentValues {
    @Entry
    public var textViewSizeCache: TextViewSizeCache = TextViewSizeCache(base: OnMemoryCache())
}
