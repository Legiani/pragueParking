//
//  ZoneLayer.swift
//  pragueParking
//
//  Created by Jakub Bednář on 22.06.2021.
//

import Foundation
import MapKit

// MARK: - Properties
struct Properties: Codable {
    let id: String
    let midpoint: [Double]
    let name: String
    let northeast: [Double]
    let numberOfPlaces: Int
    let paymentLink: String
    let southwest: [Double]
    let type: TypeClass
    let updatedAt: Int
    let zpsID: Int?
    let zpsIDS: [Int]?
    let tariffsText: String
    let tariffIDS: [String?]

    enum CodingKeys: String, CodingKey {
        case id, midpoint, name, northeast
        case numberOfPlaces = "number_of_places"
        case paymentLink = "payment_link"
        case southwest, type
        case updatedAt = "updated_at"
        case zpsID = "zps_id"
        case zpsIDS = "zps_ids"
        case tariffsText = "tariffs_text"
        case tariffIDS = "tariff_ids"
    }
}

// MARK: - TypeClass
struct TypeClass: Codable {
    let w: String?
    let id: Int
    let typeDescription: String?

    enum CodingKeys: String, CodingKey {
        case w, id
        case typeDescription = "description"
    }
}

extension MKMapView {
    func addZonePolygons(selectedID: String? = nil) {
        
        guard self.overlays.count < 5 else {
            return
        }
        if let path = Bundle.main.path(forResource: "ZonePolygons", ofType: "geojson") {
           do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
            
                let geoJSONFeatures = try MKGeoJSONDecoder().decode(data)
                
                guard let features = geoJSONFeatures as? [MKGeoJSONFeature] else {
                    print("eeeeeeeeeeerror")
                    return
                }
                
                for feature in features {

                    let properties = try?JSONDecoder.init().decode(Properties.self, from: feature.properties!)
                    let id = properties?.id
                    let typeId = properties?.type.id
                    let typeString = properties?.type.w
                    
                    if let poly = feature.geometry[0] as? MKPolygon {
                        let overlay = ZonePolygon.init(points: poly.points(), count: poly.pointCount, interiorPolygons: poly.interiorPolygons)

                        overlay.name = "ZonePolygons"
                        overlay.title =  id
                        overlay.subtitle = typeString
                        overlay.typeId = typeId
                        overlay.color = getZoneColor(typeId: typeId, selected: id == selectedID)
                                                
                        self.addOverlay(overlay)
                    }
                    if let poly = feature.geometry[0] as? MKMultiPolygon {
                        let overlay = ZoneMultiPolygon.init(poly.polygons)
                        
                        overlay.name = "ZonePolygons"
                        overlay.title =  id
                        overlay.subtitle = typeString
                        overlay.typeId = typeId
                        overlay.color = getZoneColor(typeId: typeId, selected: id == selectedID)
                                                
                        self.addOverlay(overlay)
                    }
                }
                
           } catch {
                print("error :::")
                print(error)
           }
        }
    }
    func removeZonePolygons() {
        for overlay in self.overlays {
            if let colored = overlay as? ZonePolygon {
                if (colored.name == "ZonePolygons") {
                    self.removeOverlay(overlay)
                }
            } else if let colored = overlay as? ZoneMultiPolygon {
                if (colored.name == "ZonePolygons") {
                    self.removeOverlay(overlay)
                }
            }
        }
    }
}

func getZoneColor(typeId: Int? = 1, selected: Bool = false) -> UIColor {
    var color: UIColor = .blue
    if typeId == 1 { //Rezidentní úsek
        color = .blue
    }else if typeId == 2 { //Smíšený úsek
        color = .purple
    }else if typeId == 3 { //Návštěvnický úsek
        color = .orange
    }
    
    if !selected {
        color = color.withAlphaComponent(0.2)
    }
    
    return color
}
