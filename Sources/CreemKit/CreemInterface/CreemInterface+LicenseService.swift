//
//  CreemInterface+LicenseService.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import Foundation

extension CreemInterface: LicenseService {
    public nonisolated
    func activate(_ payload: Requests.LicenseService.Activate) async throws -> License {
        try await makeRequest(path: "/v1/licenses/activate", body: payload).object
    }

    public nonisolated
    func validate(_ payload: Requests.LicenseService.Validate) async throws -> License {
        try await makeRequest(path: "/v1/licenses/validate", body: payload).object
    }

    public nonisolated
    func deactivate(_ payload: Requests.LicenseService.Deactivate) async throws -> License {
        try await makeRequest(path: "/v1/licenses/deactivate", body: payload).object
    }
}
