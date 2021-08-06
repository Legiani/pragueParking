//
//  APIManager.swift
//  pragueParking
//
//  Created by Jakub Bednář on 23.06.2021.
//

import Foundation
import Alamofire


class base {
    var URL: String = ""
    var METHOD: HTTPMethod = .get
    
    var PARAMETERS: [String : Any] = [:]
    var HEADERS: HTTPHeaders = [:]
    var ENCODING: ParameterEncoding = URLEncoding.default

    var API: String = "ParkingAPI"
    
    
    init() {
        if Thread.current.isMainThread {
            HEADERS = APIKeys.APIFullHeader(forAPI: "\(API)")
        } else {
            DispatchQueue.main.sync {
                HEADERS = APIKeys.APIFullHeader(forAPI: "\(API)")
            }
        }
    }
}

///      End point který vypiče ceny staní na parkovací zone
class getPriceListRequest: base {
    
    init(licensePlate: String, placeCode: String, parkMachine: String? = nil){
        super.init()
        URL = APIKeys.serverURLString(forAPI: API)! + "/api/v1/price-lists"
        PARAMETERS = [
            "LicensePlate" : licensePlate,
            "PlaceCode" : placeCode,
        ]
        if parkMachine != nil {
            PARAMETERS["ParkMachine"] = parkMachine
        }
    }
}

///     End point který aktivuje oveří platbu apple pay
class postApplePayPaymentRequest: base {
    
    init(applePaymentToken: String, priceListItemId: String, sourceApplication: String){
        super.init()
        METHOD = .post
        ENCODING = JSONEncoding.prettyPrinted
        HEADERS.add(name: "Content-Type" , value: "application/json")
        
        URL = APIKeys.serverURLString(forAPI: API)! + "/api/v1/payments/applepay"
        
        PARAMETERS["applePaymentToken"] = applePaymentToken
        PARAMETERS["priceListItemId"] = priceListItemId
        PARAMETERS["sourceApplication"] = sourceApplication

    }
}

///      End point který aktivuje oveří prodloužení platby apple pay
class postApplePayPaymentExtendRequest: base {
    
    init(parentRequestId: String){
        super.init()
        METHOD = .put
        URL = APIKeys.serverURLString(forAPI: API)! + "/api/v1/payments/extend/\(parentRequestId)"
    }
}
