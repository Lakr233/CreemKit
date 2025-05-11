//
//  Errors.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import Foundation

public enum Errors: Error, Sendable {
    case networkError(Error)
    case decodingError(Error)
    case encodingError(Error)
    case apiError(statusCode: Int, message: String?)
    case invalidURL
    case missingData
    case upstreamError(message: String)
    case unknownError(Error? = nil)
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .networkError(error):
            return "Network error: \(error.localizedDescription)"
        case let .decodingError(error):
            return "Decoding error: \(error.localizedDescription)"
        case let .encodingError(error):
            return "Encoding error: \(error.localizedDescription)"
        case let .apiError(statusCode, message):
            return "API error (\(statusCode)): \(message ?? "No details")"
        case .invalidURL:
            return "Invalid URL"
        case .missingData:
            return "Missing data"
        case let .upstreamError(message):
            return "Upstream error: \(message)"
        case let .unknownError(error):
            if let error { return "Unknown error: \(error.localizedDescription)" }
            return "Unknown error"
        }
    }

    public var localizedDescription: String {
        switch self {
        case let .networkError(error):
            return "Network error: \(error.localizedDescription)"
        case let .decodingError(error):
            return "Decoding error: \(error.localizedDescription)"
        case let .encodingError(error):
            return "Encoding error: \(error.localizedDescription)"
        case let .apiError(statusCode, message):
            return "API error (\(statusCode)): \(message ?? "No details")"
        case .invalidURL:
            return "Invalid URL"
        case .missingData:
            return "Missing data"
        case let .upstreamError(message):
            return "Upstream error: \(message)"
        case let .unknownError(error):
            if let error {
                return "Unknown error: \(error.localizedDescription)"
            }
            return "Unknown error"
        }
    }
}
