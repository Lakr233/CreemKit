# CreemKit

A Swift library designed for [Creem](https://creem.io) users to securely interact with the Creem API, providing license activation, validation, and management functionalities.

## Quick Start

Add the following dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/Lakr233/CreemKit.git", from: "0.2.0")
```

### Interacting via CreemProxy

If you are using CreemKit with in your client application, that is distributed to end users, it is likely you want to use [CreemProxy](https://github.com/Lakr233/CreemProxy) too. This will ensure that your API keys are not exposed to the end users, and CreemProxy was built to have basical security features to prevent abuse.

```swift
import CreemKit
import CreemProxyKit

let creemInterface = CreemInterfaceViaProxy(
    host: "your-proxy-host.example.com",
    certificateFingerprint: .matchHash("YOUR_CERTIFICATE_FINGERPRINT"),
    signingPublicKey: .verifyWithPublicKey("YOUR_SIGNING_PUBLIC_KEY")
)
let activationResult = try await creemInterface.activate...
```

### Interacting Directly with Creem API

Suitable for trusted environments (e.g., your own server):

```swift
import CreemKit

let creemInterface = CreemInterface(
    apiKey: "YOUR_API_KEY",
    apiHost: "api.creem.io" // Optional, defaults to the production environment
)
let activationResult = try await creemInterface.activate...
```

## License

MIT License. See [LICENSE](LICENSE) for details.

---

Copyright © 2025 Lakr Aream. All Rights Reserved.
