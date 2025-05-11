//
//  SigningOption.swift
//  CreemKit
//
//  Created by 秋星桥 on 5/12/25.
//
import Foundation

public enum SigningOption: Equatable, Sendable {
    case ignored
    case verifyWithPublicKey(String) // base64 encoded
}
