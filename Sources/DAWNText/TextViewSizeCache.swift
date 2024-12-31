import Foundation
import SwiftUI

public struct TextViewSizeCacheKey: Sendable, Hashable {
    let width: Double
    let attributedStringHashValue: Int
    let fontHashValue: Int
    let numberOfLines: Int
}

public typealias TextViewSizeCache = AnyCache<TextViewSizeCacheKey, CGSize>

extension EnvironmentValues {
    @Entry
    public var textViewSizeCache: TextViewSizeCache = TextViewSizeCache(base: OnMemoryCache())
}
