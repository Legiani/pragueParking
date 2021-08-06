//
//  PaymentHandler.swift
//  pragueParking
//
//  Created by Jakub Bednář on 23.06.2021.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {

    static let supportedNetworks: [PKPaymentNetwork] = [
        .masterCard,
        .visa
    ]

    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    var priceListItemID: String?

    func startPayment(paymentSummaryItems: [PKPaymentSummaryItem], priceListItemID: String, completion: @escaping PaymentCompletionHandler) {

            self.priceListItemID = priceListItemID
            completionHandler = completion

            // Create our payment request
            let paymentRequest = PKPaymentRequest()
            paymentRequest.paymentSummaryItems = paymentSummaryItems
            paymentRequest.merchantIdentifier = "merchant.cz.parkovani"
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.countryCode = "CZ"
            paymentRequest.currencyCode = "CZK"
            paymentRequest.requiredShippingContactFields = [.emailAddress]
            paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
            

            // Display our payment request
            paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
            paymentController?.delegate = self
            paymentController?.present(completion: { (presented: Bool) in
                if presented {
                    NSLog("Presented payment controller")
                } else {
                    NSLog("Failed to present payment controller")
                    self.completionHandler!(false)
                 }
             })
      }
}

/*
    PKPaymentAuthorizationControllerDelegate conformance.
*/
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        // Perform some very basic validation on the provided contact information
        if payment.shippingContact?.emailAddress == nil {
            paymentStatus = .failure
        } else {
            print("PriceListID:")
            print(self.priceListItemID!)
            print("PaymentToken:")
            let paymentToken = payment.token.paymentData.base64EncodedString()
            print(paymentToken)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                let request = postApplePayPaymentRequest(applePaymentToken: paymentToken, priceListItemId: self.priceListItemID!, sourceApplication: "PidLitacka")
                Observer().getPriceList(request: request)
            })
            self.paymentStatus = .success
        }
        completion(paymentStatus)
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
}
