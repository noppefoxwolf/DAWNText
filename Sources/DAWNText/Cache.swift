import Foundation

public protocol Cache: AnyObject {
    associatedtype Key: Hashable
    associatedtype Value
    
    subscript(key: Key) -> Value? { get set }
    var keys: [Key] { get }
}

public final class AnyCache<Key: Hashable, Value>: Cache {
    let keysGetter: () -> [Key]
    let getter: (Key) -> Value?
    let setter: (Key, Value?) -> Void
    
    public init<T>(base: T) where T: Cache, T.Key == Key, T.Value == Value {
        keysGetter = { base.keys }
        getter = { base[$0] }
        setter = { base[$0] = $1 }
    }
    
    public var keys: [Key] { keysGetter() }
    
    public subscript(key: Key) -> Value? {
        get { getter(key) }
        set { setter(key, newValue) }
    }
}

final class OnMemoryCache<Key: Hashable, Value>: Cache {
    var keys: [Key] { cache.keys.map(\.self) }
    var cache: [Key : Value] = [:]
    
    subscript(key: Key) -> Value? {
        get { cache[key] }
        set { cache[key] = newValue }
    }
}
