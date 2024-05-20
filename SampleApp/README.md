# Testing

## Demo
In order to test the Onfido SDK we need a `sdkToken`. According to documentation you may have sandbox or production tokens. However there is one more which is called `demo` you can use this token to test the UI.

## Real Tokens

Production and Sandbox tokens are actually JWT. You can create your own JWT to test the UI as well. SDK can't verify the JWT it can only try to decode it to `SDKToken` structure to check the validatity of JSON. Since I don't have access to source code below models are found out by reverse engineering the iOS SDK.

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

```swift
struct Payload: Codable {
    let app: String
    let applicationId:String
    let clientUUID: String
    let isSandbox: Bool

    enum CodingKeys: String, CodingKey {
        case app
        case applicationId = "application_id"
        case clientUUID = "client_uuid"
        case isSandbox = "is_sandbox"
    }
}
```

### EnterpriseFeatures (Enterprise Features are camelCase 🐫)
```swift
struct EnterpriseFeatures: Codable {
    let hideOnfidoLogo: Bool?
    let useMediaCallback: Bool?
    let disableSDKAnalytics: Bool?
}
```


### Urls

```swift
struct Urls: Codable {
    let detectDocumentURL: String
    let syncURL: String
    let hostedSDKURL: String
    let authURL: String
    let onfidoAPIURL: String
    let telephonyURL: String

    enum CodingKeys: String, CodingKey {
        case detectDocumentURL = "detect_document_url"
        case syncURL = "sync_url"
        case hostedSDKURL = "hosted_sdk_url"
        case authURL = "auth_url"
        case onfidoAPIURL = "onfido_api_url"
        case telephonyURL = "telephony_url"
    }
}
```

## Creating Mock Server

