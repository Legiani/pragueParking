//
//  ZoneGroupLayer.swift
//  pragueParking
//
//  Created by Jakub Bednář on 22.06.2021.
//

import Foundation
import MapKit

extension MKMapView {

    func addZoneGroupPolygons() {
        guard self.overlays.count < 5 else {
            return
        }
        
        //Add prague border
        if let path = Bundle.main.path(forResource: "ZoneGroupPolygons", ofType: "geojson") {
           do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
            
                let geoJSONFeatures = try MKGeoJSONDecoder().decode(data)
                
                guard let features = geoJSONFeatures as? [MKGeoJSONFeature] else {
                    print("eeeeeeeeeeerror")
                    return
                }
                
                for feature in features {
                    if let poly = feature.geometry[0] as? MKMultiPolygon {
                        let polygon = ColorMultiPolygon.init(poly.polygons)
                        polygon.strokeColor = .blue
                        polygon.fillColor = .blue.withAlphaComponent(0.1)
                        polygon.name = "ZoneGroupPolygons"
                        self.addOverlay(polygon)
                    }
                    if let poly = feature.geometry[0] as? MKPolygon {
                       let polygon = ColorPolygon.init(points: poly.points(), count: poly.pointCount, interiorPolygons: poly.interiorPolygons)
                        polygon.strokeColor = .blue
                        polygon.fillColor = .blue.withAlphaComponent(0.1)
                        polygon.name = "ZoneGroupPolygons"
                        self.addOverlay(polygon)
                    }
                }
                
           } catch {
                print("error :::")
                print(error)
           }
        }
    }
    func removeZoneGroupPolygons() {
        for overlay in self.overlays {
            if let colored = overlay as? ColorPolygon {
                if (colored.name == "ZoneGroupPolygons") {
                    self.removeOverlay(overlay)
                }
            } else if let colored = overlay as? ColorMultiPolygon {
                if (colored.name == "ZoneGroupPolygons") {
                    self.removeOverlay(overlay)
                }
            }
        }
    }
}
