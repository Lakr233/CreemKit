//
//  CreemInterfaceViaProxy.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import CreemKit
import Foundation

public class CreemInterfaceViaProxy: CreemInterface, @unchecked Sendable {
    public nonisolated let apiPort: Int
    public nonisolated let urlSessionDelegate: PinSessionDelegate
    public nonisolated let signing: SigningCurve25519?

    public init(
        host: String, // can be an IP address or domain name
        port: Int = 443,
        certificateFingerprint: CertificateFingerprintOption = .systemDefault,
        signingPublicKey: SigningOption = .ignored
    ) {
        apiPort = port
        urlSessionDelegate = .init(certificateFingerprint: certificateFingerprint)
        switch signingPublicKey {
        case .ignored: signing = nil
        case let .verifyWithPublicKey(key): signing = .init(base64Encoded: key)
        }

        let session = URLSession(configuration: .ephemeral, delegate: urlSessionDelegate, delegateQueue: nil)

        #if DEBUG
            if certificateFingerprint == .allowAny, signingPublicKey == .ignored {
                print("⚠️ You are using insecure settings. This is not recommended.")
            }
        #endif

        super.init(
            apiKey: "",
            apiHost: host,
            urlSession: session
        )
    }

    @available(*, deprecated, message: "This initializer is not supported. Use the other initializer instead.")
    override public init(apiKey _: String, apiHost _: String = "api.creem.io", urlSession _: URLSession = .shared) {
        fatalError()
    }

    override public nonisolated func buildUrlComponents() -> URLComponents {
        var comps = super.buildUrlComponents()
        comps.port = apiPort
        return comps
    }

    override public nonisolated func makeRequest<T: CreemObject>(
        path: String,
        method: String = "POST",
        body: some CreemObject
    ) async throws -> RequestResult<T> {
        let result: RequestResult<T> = try await super.makeRequest(
            path: path,
            method: method,
            body: body
        )

        if let signing {
            let response = result.response as! HTTPURLResponse
            if let signature = response.allHeaderFields["x-api-signature"] as? String, !signature.isEmpty {
                guard let signatureData = Data(base64Encoded: signature) else {
                    throw SigningError.invalidSignature
                }
                try signing.check(
                    signature: signatureData,
                    message: result.data
                )
            } else {
                throw SigningError.invalidSignature
            }
        }

        return result
    }
}
