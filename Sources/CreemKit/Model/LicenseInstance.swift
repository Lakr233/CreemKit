//
//  LicenseInstance.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import Foundation

public struct LicenseInstance: CreemObject, Identifiable {
    public let id: String
    public let mode: LicenseInstanceEntityMode
    public let object: String
    public let name: String
    public let status: LicenseInstanceEntityStatus
    public let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, mode, object, name, status
        case createdAt = "created_at"
    }

    public enum LicenseInstanceEntityMode: String, CreemObject {
        case test
        case live
        case sandbox
        case prod
    }

    public enum LicenseInstanceEntityStatus: String, CreemObject {
        case active
        case deactivated
    }
}
