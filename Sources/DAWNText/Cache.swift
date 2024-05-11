import Foundation

public protocol Cache: AnyObject {
    associatedtype Key: Hashable
    associatedtype Value
    
    subscript(key: Key) -> Value? { get set }
}

public final class AnyCache<Key: Hashable, Value>: Cache {
    let getter: (Key) -> Value?
    let setter: (Key, Value?) -> Void
    
    public init<T>(base: T) where T: Cache, T.Key == Key, T.Value == Value {
        getter = { base[$0] }
        setter = { base[$0] = $1 }
    }
    
    public subscript(key: Key) -> Value? {
        get { getter(key) }
        set { setter(key, newValue) }
    }
}

final class OnMemoryCache<Key: Hashable, Value>: Cache {
    var cache: [Key : Value] = [:]
    
    subscript(key: Key) -> Value? {
        get { cache[key] }
        set { cache[key] = newValue }
    }
}
