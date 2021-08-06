//
//  MapPoligon.swift
//  pragueParking
//
//  Created by Jakub Bednář on 21.06.2021.
//

import Foundation
import MapKit

class ZonePolygon: MKPolygon {
    var name: String?
    var typeId: Int?
    var color: UIColor?
    var borderColor: UIColor? {
        color?.withAlphaComponent(0.5)
    }
}
class ZoneMultiPolygon: MKMultiPolygon {
    var name: String?
    var typeId: Int?
    var color: UIColor?
    var borderColor: UIColor? {
        color?.withAlphaComponent(0.5)
    }
}

class ColorPolygon: MKPolygon {
    var name: String?
    var fillColor: UIColor?
    var strokeColor: UIColor?
}

class ColorMultiPolygon: MKMultiPolygon {
    var name: String?
    var fillColor: UIColor?
    var strokeColor: UIColor?
}
