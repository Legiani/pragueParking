//
//  PragueLayer.swift
//  pragueParking
//
//  Created by Jakub Bednář on 22.06.2021.
//

import Foundation
import MapKit

extension MKMapView {
    func addPraguePoligonBorder() {
        //Add prague border
        if let path = Bundle.main.path(forResource: "Prague", ofType: "geojson") {
           do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
            
                let geoJSONFeatures = try MKGeoJSONDecoder().decode(data)
                
                guard let features = geoJSONFeatures as? [MKGeoJSONFeature] else {
                    print("eeeeeeeeeeerror")
                    return
                }
                
                for feature in features {
                    if let poly = feature.geometry[0] as? MKPolygon {
                        let polygon = ColorPolygon.init(points: poly.points(), count: poly.pointCount, interiorPolygons: poly.interiorPolygons)
                        polygon.strokeColor = .red
                        polygon.fillColor = .red.withAlphaComponent(0.1)
                        polygon.name = "Prague"
                        self.addOverlay(polygon)
                    }
                }
                
           } catch {
                print("error :::")
                print(error)
           }
        }
    }
    func removePraguePologonBorder() {
        for overlay in self.overlays {
            if let colored = overlay as? ColorPolygon {
                if (colored.name == "Prague") {
                    self.removeOverlay(overlay)
                }
            }
        }
    }
}
