//
//  License.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import Foundation

public struct License: CreemObject, Identifiable {
    public let id: String
    public let mode: LicenseEntityMode
    public let object: String
    public let status: LicenseEntityStatus
    public let key: String
    public let activation: Int
    public let activationLimit: Int?
    public let expiresAt: String?
    public let createdAt: String
    public let instance: LicenseInstance?

    public enum LicenseEntityMode: String, CreemObject {
        case test
        case live
        case sandbox
    }

    public enum LicenseEntityStatus: String, CreemObject {
        case inactive
        case active
        case expired
        case disabled
    }

    enum CodingKeys: String, CodingKey {
        case id, mode, object, status, key, activation, instance
        case activationLimit = "activation_limit"
        case expiresAt = "expires_at"
        case createdAt = "created_at"
    }
}
