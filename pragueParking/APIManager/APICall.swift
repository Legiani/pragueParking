//
//  APICall.swift
//  pragueParking
//
//  Created by Jakub Bednář on 23.06.2021.
//

import Foundation
import SwiftUI
import Alamofire

class Observer : ObservableObject{
    @Published var priceListItem: [PriceListItem]?

    func getPriceList(request: getPriceListRequest) {
        AF.request(request.URL, method: request.METHOD, parameters: request.PARAMETERS, encoding: request.ENCODING, headers: request.HEADERS)
            .responseJSON{
                response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodeResponse = try decoder.decode(PriceList.self, from: data)
                    self.priceListItem = decodeResponse.data.priceListItems
                } catch let error {
                    print(error)
                }
        }
    }
    
    func getPriceList(request: postApplePayPaymentRequest) {
        AF.request(request.URL, method: request.METHOD, parameters: request.PARAMETERS, encoding: JSONEncoding.prettyPrinted, headers: request.HEADERS)
            .responseJSON{
                response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }

                guard let data = response.data else { return }
                do {
                    print("request body: \(response.request?.httpBody?.base64EncodedString())")
                    let decoder = JSONDecoder()
                    let decodeResponse = try decoder.decode(ApplePayPaymentResponse.self, from: data)
                    print(decodeResponse)
                } catch let error {
                    print(error)
                }
        }
    }
}
