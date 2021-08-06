// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let priceList = try? newJSONDecoder().decode(PriceList.self, from: jsonData)

import Foundation

// MARK: - PriceList
struct PriceList: Codable {
    let data: DataClass
    var succeeded: Bool
    let message, errors: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let created, validUntil, message: String?
    let priceListItems: [PriceListItem]?
}

// MARK: - PriceListItem
struct PriceListItem: Codable, Hashable{
    let priceListItemID: String
    let label: String
    let from: String
    let to: String
    let currency: String?
    let price: Int
    let message, duration: String?

    enum CodingKeys: String, CodingKey {
        case priceListItemID = "priceListItemId"
        case label, from, to, currency, price, message, duration
    }
}

extension PriceListItem: Identifiable {
  var id: String {  priceListItemID }
}
