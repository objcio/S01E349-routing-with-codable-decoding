//

import Foundation

struct RouteDecodingError: Error { }

public func decode<R: Decodable>(_ path: String) throws -> R {
    guard path.first == "/" else {
        throw RouteDecodingError()
    }
    let components = path.dropFirst().split(separator: "/", omittingEmptySubsequences: false).map { String($0) }
    let decoder = RouteDecoder(components: Box(components))
    return try R.init(from: decoder)
}

struct RouteDecoder: Decoder {
    var components: Box<[String]>
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer(RouteKDC(components: components))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}

struct RouteKDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var components: Box<[String]>
    var codingPath: [CodingKey] = []
    var allKeys: [Key] = []

    init(components: Box<[String]>) {
        self.components = components
        if let c = components.value.first, let k = Key(stringValue: c) {
            self.components.value.removeFirst()
            allKeys = [k]
        }
    }

    func contains(_ key: Key) -> Bool {
        if key.stringValue.hasPrefix("_") {
            return true
        }
        return false
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        return components.value.isEmpty
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        fatalError()
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        fatalError()
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        fatalError()
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        fatalError()
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard let f = components.value.first, let i = Int(f) else {
            throw RouteDecodingError()
        }
        return i
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        fatalError()
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        fatalError()
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        fatalError()
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        fatalError()
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        fatalError()
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        fatalError()
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        fatalError()
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        fatalError()
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        fatalError()
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        let decoder = RouteDecoder(components: components)
        return try T(from: decoder)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        KeyedDecodingContainer(RouteKDC<NestedKey>(components: components))
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func superDecoder() throws -> Decoder {
        fatalError()
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }
}
