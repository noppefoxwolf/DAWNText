import Foundation

struct TextViewSizeCacheRetriever {
    let cache: TextViewSizeCache
    
    func sizeThatFits(_ key: TextViewSizeCacheKey) -> CGSize? {
        if let size = cache[key] {
            return size
        }
        let equalTypographyCacheKeys = cache.keys.filter { $0.isEqualTypography(to: key) }
        let intrinsicContentSizeCacheKey = equalTypographyCacheKeys.first(where: { $0.width == 0 })
        
        if let intrinsicContentSizeCacheKey, let cachedSize = cache[intrinsicContentSizeCacheKey], cachedSize.width < key.width {
            return cachedSize
        } else if key.numberOfLines == 1, let k = equalTypographyCacheKeys.first(where: { $0.width < key.width }), k.width <= key.width {
            return cache[k]
        } else {
            return nil
        }
    }
}

extension TextViewSizeCacheKey {
    func isEqualTypography(to other: TextViewSizeCacheKey) -> Bool {
        other.attributedStringHashValue == attributedStringHashValue && other.fontHashValue == fontHashValue && other.numberOfLines == numberOfLines
    }
}
