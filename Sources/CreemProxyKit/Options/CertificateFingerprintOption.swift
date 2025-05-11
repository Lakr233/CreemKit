//
//  CertificateFingerprintOption.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//

import Foundation

public enum CertificateFingerprintOption: Equatable, Sendable {
    case allowAny
    case matchHash(String)
    case systemDefault
}
