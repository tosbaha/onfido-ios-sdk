//
//  JWTService.swift
//  SampleApp
//
//  Created by Mustafa on 25.05.2024.
//  Copyright © 2024 example. All rights reserved.
//

import Foundation
import CommonCrypto

class JWTService {
    let secret:String
    init(secret:String) {
        self.secret = secret
    }
    
    func base64UrlEncode(data: Data) -> String? {
        let base64 = data.base64EncodedString()
        let base64Url = base64.replacingOccurrences(of: "+", with: "-")
                              .replacingOccurrences(of: "/", with: "_")
                              .replacingOccurrences(of: "=", with: "")
        return base64Url
    }

    func HMACSHA256(data: String, key: Data) -> Data? {
        guard let stringData = data.data(using: .utf8) else { return nil }
        var result = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        result.withUnsafeMutableBytes { resultBytes in
            stringData.withUnsafeBytes { stringBytes in
                key.withUnsafeBytes { keyBytes in
                    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyBytes, key.count, stringBytes, stringData.count, resultBytes)
                }
            }
        }
        return result
    }

    func createJWT(sdkTokenJson: String) -> String? {
        do {
            let header = ["alg": "HS256", "typ": "JWT"]
            let headerData = try JSONSerialization.data(withJSONObject: header, options: [])
            guard let headerBase64 = base64UrlEncode(data: headerData) else {
                return nil
            }

            let now = Date()
            let iat = Int(now.timeIntervalSince1970)
            let exp = iat + 3 * 24 * 60 * 60 // Add 3 days

            // Decode SDKToken from JSON
            guard let sdkTokenData = sdkTokenJson.data(using: .utf8) else {
                return nil
            }
            var sdkTokenDict = try JSONSerialization.jsonObject(with: sdkTokenData, options: []) as! [String: Any]

            sdkTokenDict["iat"] = iat
            sdkTokenDict["exp"] = exp

            let payloadData = try JSONSerialization.data(withJSONObject: sdkTokenDict, options: [])
            guard let payloadBase64 = base64UrlEncode(data: payloadData) else {
                return nil
            }

            let secretData = Data(secret.utf8)
            let signingInput = "\(headerBase64).\(payloadBase64)"
            guard let signature = HMACSHA256(data: signingInput, key: secretData),
                  let signatureBase64 = base64UrlEncode(data: signature) else {
                return nil
            }

            let jwt = "\(signingInput).\(signatureBase64)"
            return jwt
        } catch {
            print("Error creating JWT: \(error)")
            return nil
        }
    }
}
