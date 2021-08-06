//
//  APIKeys.template.swift
//  pragueParking
//
//  Created by Jakub Bednář on 21.06.2021.
//

import Foundation
import Alamofire


@objc class APIKeys : NSObject {

    //Development
    #if DEBUG
    private static let apiKeys: Dictionary<String,Dictionary<String,Any>> = [
        "ParkingAPI" : [
            "ServerURL"    : "https://adress.cz/",
            "APITokenKey" : "Bearer eyJhnananax7T1XnGs",
            "APITokenHeader" : "x-api-key"
        ]
        
    ]
    //Production
    #else
    private static let apiKeys: Dictionary<String,Dictionary<String,Any>> = [
        "ParkingAPI" : [
            "ServerURL"    : "https://adress.cz/",
            "APITokenKey" : "Bearer eyJhblalalalalaLKJBUx7T1XnGs",
            "APITokenHeader" : "x-api-key"
        ]
    ]
    #endif
    
    /**
     return server URL (https://something.com/api)
     
    */
    static func serverURLString(forAPI: String) -> String? {
        return APIKeys.apiKeys[forAPI]?["ServerURL"] as? String
    }
    
    /**
     return post token header (Authorization)
     
    */
    static func APITokenHeader(forAPI: String) -> String? {
        return APIKeys.apiKeys[forAPI]?["APITokenHeader"] as? String
    }
    
    /**
     return post token (jncfj2-jvnkdf-njkcnjks)
     
    */
    static func APITokenKey(forAPI: String) -> String? {
        return APIKeys.apiKeys[forAPI]?["APITokenKey"] as? String
    }
    
    /**
     return full token header [header: "Bearer nfjks 22jně 23hšb "]
     
    */
    static func APIFullHeader(forAPI: String) -> HTTPHeaders {
        let head = APIKeys.APITokenHeader(forAPI: "\(forAPI)")!
        let token = APIKeys.APITokenKey(forAPI: "\(forAPI)")!
        
        var retur: HTTPHeaders = [:]
        retur[head] = "\(token)"
        return retur
    }
}
