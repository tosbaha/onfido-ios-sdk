//
//  SDKToken.swift
//  SampleApp
//
//  Created by Mustafa on 25.05.2024.
//  Copyright © 2024 example. All rights reserved.
//

import Foundation

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

    struct EnterpriseFeatures: Codable {
        let hideOnfidoLogo: Bool?
        let useMediaCallback: Bool?
        let disableSDKAnalytics: Bool?
    }

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

}
