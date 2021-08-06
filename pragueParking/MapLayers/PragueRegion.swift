//
//  PragueRegion.swift
//  pragueParking
//
//  Created by Jakub Bednář on 03.08.2021.
//

import Foundation
import MapKit

func getPragueRegion() -> MKCoordinateRegion {
    let location = CLLocationCoordinate2D(latitude: 50.075538, longitude: 14.4378)
    let region = MKCoordinateRegion(center: location, latitudinalMeters: CLLocationDistance(4000), longitudinalMeters: CLLocationDistance(8000))
    return region
}

