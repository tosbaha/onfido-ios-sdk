//
//  ViewController.swift
//
//  Copyright © 2016-2024 Onfido. All rights reserved.
//

import Onfido
import UIKit

let jsonStr = """
{
  "uuid": "1b9d6bcd-bbfd-4b2d-9b5d-ab8dfbbd4bed",
  "enterprise_features": {
    "useMediaCallback": true,
    "disableSDKAnalytics": true,
    "hideOnfidoLogo": true
  },
"urls": {
    "detect_document_url": "http://localhost:3000",
    "sync_url": "http://localhost:3000",
    "hosted_sdk_url": "http://localhost:3000",
    "auth_url": "http://localhost:3000",
    "onfido_api_url": "http://localhost:3000",
    "telephony_url": "http://localhost:3000"
  },
  "payload": {
    "app": "HELLO",
    "client_uuid": "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    "application_id": "APP_ID",
    "is_self_service_trial": false,
    "is_trial": false,
    "is_sandbox": false
  }
}
"""

final class ViewController: UIViewController {
    @IBAction
    func verifyUser(_ sender: Any) {
        // TODO: Call your backend to get `sdkToken` https://github.com/onfido/onfido-ios-sdk#31-sdk-tokens
        let service = JWTService(secret: "MySecret")
        let sdkToken = service.createJWT(sdkTokenJson: jsonStr) ?? "demo"
        
        let features = EnterpriseFeatures.builder()
           // .withCobrandingText("Acme Inc")
           // .withDisableMobileSdkAnalytics(true)
            //.withCobrandingLogo(UIImage(systemName: "person")!, cobrandingLogoDarkMode: UIImage(systemName: "circle")!)
           .withHideOnfidoLogo(true)
            .build()


        let config = try! OnfidoConfig.builder()
            .withSDKToken(sdkToken)
            .withWelcomeStep()
            .withDocumentStep()
            .withEnterpriseFeatures(features)
            .withFaceStep(ofVariant: .photo(withConfiguration: nil))
            .build()

        let responseHandler: (OnfidoResponse) -> Void = { [weak self] response in
            if case let OnfidoResponse.error(error) = response {
                self?.showError(error)
            } else if case OnfidoResponse.success = response {
                // SDK flow has been completed successfully. You may want to create a check in your backend at this
                // point. Follow https://github.com/onfido/onfido-ios-sdk#2-creating-a-check to understand how to create
                // a check
                self?.showAlert(title: "Success", message: "SDK flow has been completed successfully")
            } else if case OnfidoResponse.cancel = response {
                self?.showAlert(title: "Canceled", message: "Canceled by user")
            }
        }

        let onfidoFlow = OnfidoFlow(withConfiguration: config)
            .with(responseHandler: responseHandler)

        do {
            /*
             Supported presentation styles are:
             For iPhones: .fullScreen
             For iPads: .fullScreen and .formSheet
             Due to iOS 13 you must specify .fullScreen as the default is now .pageSheet
             */
            var modalPresentationStyle: UIModalPresentationStyle = .fullScreen

            if UIDevice.current.userInterfaceIdiom == .pad {
                modalPresentationStyle = .formSheet // to present modally on iPads
            }

            try onfidoFlow.run(from: self, presentationStyle: modalPresentationStyle)
        } catch {
            // Cannot execute the flow
            showError(error)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showError(_ error: Error) {
        showAlert(title: "Error", message: String(describing: error))
    }
}
