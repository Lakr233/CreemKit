//
//  SigningCurve25519.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import CommonCrypto
import CryptoKit
import Foundation

public enum SigningError: Error {
    case invalidSignature
}

public final class SigningCurve25519: Sendable {
    public let publicKey: Curve25519.Signing.PublicKey

    public init(publicKey: Curve25519.Signing.PublicKey) {
        self.publicKey = publicKey
    }

    // if you crashed here, dont submit an issue, its your fault
    public convenience init(base64Encoded: String) {
        guard let data = Data(base64Encoded: base64Encoded) else {
            fatalError("invalid base64 string")
        }
        self.init(publicKey: try! Curve25519.Signing.PublicKey(
            rawRepresentation: data
        ))
    }

    public func check(signature: Data, message: Data) throws {
        if !publicKey.isValidSignature(signature, for: message) {
            throw SigningError.invalidSignature
        }
    }
}

extension SigningError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidSignature:
            "Invalid signature"
        }
    }

    public var localizedDescription: String {
        switch self {
        case .invalidSignature:
            "Invalid signature"
        }
    }
}
