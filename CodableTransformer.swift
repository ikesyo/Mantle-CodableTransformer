import Foundation
import Mantle
import ObjectEncoder

public enum CodableTransformerError: Error {
    case invalidInput(expected: String, actual: String)
}

extension ValueTransformer {
    private static func decodingBlock<T: Decodable>(_ type: T.Type, decoder: ObjectDecoder) -> MTLValueTransformerBlock {
        return { value, successPointer, errorPointer -> Any? in
            guard let unwrapped = value else {
                successPointer?.pointee = false
                errorPointer?.pointee = CodableTransformerError
                    .invalidInput(
                        expected: "\(type)-convertible JSON",
                        actual: "\(String(describing: value))"
                    ) as NSError
                return nil
            }

            do {
                let decoded: T = try decoder.decode(from: unwrapped)
                return decoded
            } catch {
                successPointer?.pointee = false
                errorPointer?.pointee = error as NSError
                return nil
            }
        }
    }

    private static func encodingBlock<T: Encodable>(_ type: T.Type, encoder: ObjectEncoder) -> MTLValueTransformerBlock {
        return { (value, successPointer, errorPointer) -> Any? in
            guard let unwrapped = value as? T else {
                successPointer?.pointee = false
                errorPointer?.pointee = CodableTransformerError
                    .invalidInput(
                        expected: "\(type)",
                        actual: "\(String(describing: value))"
                    ) as NSError
                return nil
            }

            do {
                let encoded = try encoder.encode(unwrapped)
                return encoded
            } catch {
                successPointer?.pointee = false
                errorPointer?.pointee = error as NSError
                return nil
            }
        }
    }

    public static func mtl_decodableTransformer<T: Decodable>(
        _ type: T.Type = T.self,
        decoder: ObjectDecoder = ObjectDecoder()
    ) -> ValueTransformer {
        return MTLValueTransformer(
            usingForwardBlock: decodingBlock(type, decoder: decoder)
        )
    }

    public static func mtl_encodableTransformer<T: Encodable>(
        _ type: T.Type = T.self,
        encoder: ObjectEncoder = ObjectEncoder()
    ) -> ValueTransformer {
        return MTLValueTransformer(
            usingForwardBlock: encodingBlock(type, encoder: encoder)
        )
    }

    public static func mtl_codableTransformer<T: Codable>(
        _ type: T.Type = T.self,
        decoder: ObjectDecoder = ObjectDecoder(),
        encoder: ObjectEncoder = ObjectEncoder()
    ) -> ValueTransformer {
        return MTLValueTransformer(
            usingForwardBlock: decodingBlock(type, decoder: decoder),
            reverse: encodingBlock(type, encoder: encoder)
        )
    }
}
