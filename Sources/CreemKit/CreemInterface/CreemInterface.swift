//
//  CreemInterface.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import Foundation

/// A service implementation that interacts directly with the Creem API.
open class CreemInterface {
    public nonisolated let apiKey: String
    public nonisolated let apiHost: String
    public nonisolated let urlSession: URLSession

    /// Initializes a new CreemInterface.
    /// - Parameters:
    ///   - apiKey: The API key.
    ///   - apiHost: The API host address (default is "api.creem.io").
    ///   - urlSession: The URL session (default is the shared session).
    public nonisolated
    init(apiKey: String, apiHost: String = "api.creem.io", urlSession: URLSession = .init(
        configuration: .ephemeral,
        delegate: nil,
        delegateQueue: nil
    )) {
        self.apiKey = apiKey
        self.apiHost = apiHost
        self.urlSession = urlSession
    }

    /// Build URL components for the API request using provided host
    /// - Returns: URLComponents object with scheme and host set.
    open nonisolated
    func buildUrlComponents() -> URLComponents {
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = apiHost
        return comps
    }

    public typealias RequestResult<T: CreemObject> = (
        response: URLResponse,
        data: Data,
        object: T
    )
    /// A generic method for creating and sending requests.
    /// - Parameters:
    ///   - path: The API path.
    ///   - method: The HTTP method.
    ///   - body: The request body.
    /// - Returns: The decoded response object.
    open nonisolated
    func makeRequest<T: CreemObject>(
        path: String,
        method: String = "POST",
        body: some CreemObject
    ) async throws -> RequestResult<T> {
        var comps = buildUrlComponents()
        comps.path = path

        guard let url = comps.url else { throw Errors.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        if !apiKey.isEmpty { request.setValue(apiKey, forHTTPHeaderField: "x-api-key") }

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw Errors.encodingError(error)
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch {
            throw Errors.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Errors.networkError(URLError(.badServerResponse))
        }

        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            // Attempt to decode the API error message.
            let errorMessage = String(data: data, encoding: .utf8)
            throw Errors.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
        }

        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return (response, data, decodedObject)
        } catch {
            throw Errors.decodingError(error)
        }
    }
}

extension CreemInterface: @unchecked Sendable {}
