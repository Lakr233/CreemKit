//
//  PinSessionDelegate.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import CommonCrypto
import CryptoKit
import Foundation

public class PinSessionDelegate: NSObject, URLSessionDelegate, @unchecked Sendable {
    public init(certificateFingerprint: CertificateFingerprintOption) {
        self.certificateFingerprint = certificateFingerprint
    }

    public nonisolated let certificateFingerprint: CertificateFingerprintOption

    public func urlSession(
        _: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard let trust = challenge.protectionSpace.serverTrust,
              SecTrustGetCertificateCount(trust) > 0,
              let certChain = SecTrustCopyCertificateChain(trust) as? [SecCertificate],
              !certChain.isEmpty
        else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        switch certificateFingerprint {
        case .allowAny:
            completionHandler(.useCredential, .init(trust: trust))
            return

        case let .matchHash(hash):
            var foundMatchedCertificates = false
            for cert in certChain where !foundMatchedCertificates {
                let data = SecCertificateCopyData(cert) as Data
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
                data.withUnsafeBytes {
                    _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
                }
                let hexBytes = digest.map { String(format: "%02hhx", $0) }
                let hex = hexBytes.joined()
                if hash.lowercased() == hex.lowercased() {
                    foundMatchedCertificates = true
                }
            }
            if foundMatchedCertificates {
                completionHandler(.useCredential, .init(trust: trust))
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
            return

        case .systemDefault:
            completionHandler(.performDefaultHandling, nil)
            return
        }
    }
}
