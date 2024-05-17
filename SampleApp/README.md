# Testing

## Demo
In order to test the Onfido SDK we need a `sdkToken`. According to documentation you may have sandbox or production tokens. However there is one more which is called `demo` you can use this token to test the UI.

## Real Tokens

Production and Sandbox tokens are actually JWT. You can create your own JWT to test the UI as well. SDK can't verify the JWT it can only try to decode it to `SDKToken` structure to check the validatity of JSON. Since I don't have access to source code below models are found out by reverse engineering the SDK.

## Models

### SDKToken

```swift
struct SDKToken: Codable {
    let payload: Payload
    let uuid: String
    let enterpriseFeatures: EnterpriseFeatures
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case payload, uuid
        case enterpriseFeatures = "enterprise_features"
        case urls
    }
}
```

### Payload

### EnterpriseFeatures

### Urls

## Creating Mock Server

