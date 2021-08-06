//
//  Extension.swift
//  pragueParking
//
//  Created by Jakub Bednář on 21.06.2021.
//

import Foundation
import MapKit

extension MKPolygon {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let point = MKMapPoint(coordinate)
        let mapRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
        return self.intersects(mapRect)
    }
}
