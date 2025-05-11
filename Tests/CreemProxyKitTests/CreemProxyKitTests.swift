@testable import CreemProxyKit
import Testing

let creemInterface = CreemInterfaceViaProxy(
    host: try! String(
        contentsOfFile: "/tmp/creem.api.test.host"
    ).trimmingCharacters(in: .whitespacesAndNewlines),
    certificateFingerprint: .matchHash("0EA6CC5707C4485FF5A93F2D452B1903E3E6773B"),
    signingPublicKey: .verifyWithPublicKey("ObReLUe4wm8rwkBF6L99yxvm8OFrV4LADID61tpMjig=")
)

@Test func testLicenseServices() async throws {
    let licenseTestKey = "6L443-AJJH8-457KH-95RY9-IZYYF"

    let licenseActivationResult = try await creemInterface.activate(
        .init(
            key: licenseTestKey,
            instanceName: "CreemKit.Test"
        )
    )
    #expect(licenseActivationResult.status == .active)
    #expect(licenseActivationResult.instance?.id != nil)
    #expect(licenseActivationResult.instance?.status == .active)

    let licenseValidationResult = try await creemInterface.validate(
        .init(
            key: licenseTestKey,
            instanceId: licenseActivationResult.instance?.id ?? ""
        )
    )
    #expect(licenseValidationResult.status == .active)
    #expect(licenseValidationResult.instance?.id != nil)
    #expect(licenseValidationResult.instance?.status == .active)

    let licenseDeactivationResult = try await creemInterface.deactivate(
        .init(
            key: licenseTestKey,
            instanceId: licenseActivationResult.instance?.id ?? ""
        )
    )
    #expect(licenseDeactivationResult.status == .active)
    #expect(licenseDeactivationResult.instance?.status == .deactivated)

    let postDeactivationLicenseValidationResult = try await creemInterface.validate(
        .init(
            key: licenseTestKey,
            instanceId: licenseActivationResult.instance?.id ?? ""
        )
    )
    #expect(postDeactivationLicenseValidationResult.status == .active)
    #expect(postDeactivationLicenseValidationResult.instance?.id != nil)
    #expect(postDeactivationLicenseValidationResult.instance?.status == .deactivated)
}
