//
//  ApplePayPayment.swift
//  pragueParking
//
//  Created by Jakub Bednář on 24.06.2021.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let applePayPayment = try? newJSONDecoder().decode(ApplePayPayment.self, from: jsonData)

import Foundation
// MARK: - ApplePayPaymentElement
struct ApplePayPaymentElement: Codable {
    let succeeded: Bool?
    let message: String?
    let errors: [String]?
    let data: DataUnion?
}

enum DataUnion: Codable {
    case dataClasss(DataClasss)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(DataClasss.self) {
            self = .dataClasss(x)
            return
        }
        throw DecodingError.typeMismatch(DataUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DataUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dataClasss(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - DataClass
struct DataClasss: Codable {
    let paymentID, requestID: String?

    enum CodingKeys: String, CodingKey {
        case paymentID = "paymentId"
        case requestID = "requestId"
    }
}

typealias ApplePayPaymentResponse = [ApplePayPaymentElement]
