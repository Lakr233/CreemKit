//
//  LicenseService.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import Foundation

public protocol LicenseService {
    // https://docs.creem.io/api-reference/endpoint/activate-license
    nonisolated
    func activate(_ payload: Requests.LicenseService.Activate) async throws -> License
    // https://docs.creem.io/api-reference/endpoint/validate-license
    nonisolated
    func validate(_ payload: Requests.LicenseService.Validate) async throws -> License
    // https://docs.creem.io/api-reference/endpoint/deactivate-license
    nonisolated
    func deactivate(_ payload: Requests.LicenseService.Deactivate) async throws -> License
}

public extension Requests {
    enum LicenseService {}
}

public extension Requests.LicenseService {
    struct Activate: CreemObject {
        public let key: String
        public let instanceName: String

        public init(key: String, instanceName: String) {
            self.key = key
            self.instanceName = instanceName
        }

        enum CodingKeys: String, CodingKey {
            case key
            case instanceName = "instance_name"
        }
    }
}

public extension Requests.LicenseService {
    struct Validate: CreemObject {
        public let key: String
        public let instanceId: String

        public init(key: String, instanceId: String) {
            self.key = key
            self.instanceId = instanceId
        }

        enum CodingKeys: String, CodingKey {
            case key
            case instanceId = "instance_id"
        }
    }
}

public extension Requests.LicenseService {
    struct Deactivate: CreemObject {
        public let key: String
        public let instanceId: String

        public init(key: String, instanceId: String) {
            self.key = key
            self.instanceId = instanceId
        }

        enum CodingKeys: String, CodingKey {
            case key
            case instanceId = "instance_id"
        }
    }
}
