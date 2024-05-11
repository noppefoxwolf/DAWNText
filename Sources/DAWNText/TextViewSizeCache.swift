import Foundation
import SwiftUI

public struct TextViewSizeCacheKey: Hashable {
    let width: Double
    let attributedStringHashValue: Int
    let fontHashValue: Int
}

public typealias TextViewSizeCache = AnyCache<TextViewSizeCacheKey, CGSize>

private struct TextViewSizeCacheEnvironmentKey: EnvironmentKey {
    static let defaultValue: TextViewSizeCache = TextViewSizeCache(base: OnMemoryCache())
}

extension EnvironmentValues {
    public var textViewSizeCache: TextViewSizeCache {
        get { self[TextViewSizeCacheEnvironmentKey.self] }
        set { self[TextViewSizeCacheEnvironmentKey.self] = newValue }
    }
}
