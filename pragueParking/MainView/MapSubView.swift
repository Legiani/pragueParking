//
//  MapView.swift
//  pragueParking
//
//  Created by Jakub Bednář on 21.06.2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    private let locationManager = CLLocationManager()
    @State private var zones: Bool = true
    @Binding public var selected: String?
    @Binding public var search: String?
    @State private var tapLocation: CLLocationCoordinate2D?
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        self.locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.addPraguePoligonBorder()
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 60000), animated: true)
        mapView.setRegion(getPragueRegion(), animated: true)

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        zoneLayerController(view: view)
        searchAnnotationController(view: view)
    }
    
    func searchAnnotationController(view: MKMapView){
        view.removeAnnotations(view.annotations)
        
        guard $search.wrappedValue != nil else { return }
            
        let geocoder = MKLocalSearch.Request()
        geocoder.region = getPragueRegion()
        geocoder.naturalLanguageQuery = $search.wrappedValue!
        let search = MKLocalSearch(request: geocoder)

        search.start { response, error in
            guard error == nil else { return }
            guard let response = response else { return }
            guard response.mapItems.count > 0 else { return }

            let placemark = response.mapItems.first?.placemark
            guard let annotation = placemark else { return }
            view.addAnnotation(annotation)
                
            let region = MKCoordinateRegion(center: annotation.location!.coordinate, latitudinalMeters: CLLocationDistance(400), longitudinalMeters: CLLocationDistance(400))
            view.setRegion(region, animated: true)
        }
    }
    
    func zoneLayerController(view: MKMapView) {
        if $zones.wrappedValue {
            view.removeZonePolygons()
            view.addZoneGroupPolygons()
        }else {
            if view.overlays.count < 100 {
                view.removeZoneGroupPolygons()
                view.addZonePolygons(selectedID: $selected.wrappedValue)
            }else {
                for overlay in view.overlays {
                    if let selected = overlay as? ZonePolygon {
                        if let renderer = view.renderer(for: selected) as? MKPolygonRenderer {
                            if (selected.title == $selected.wrappedValue) {
                                renderer.fillColor = getZoneColor(typeId: selected.typeId, selected: true)
                            }else{
                                renderer.fillColor = getZoneColor(typeId: selected.typeId, selected: false)
                            }
                        }
                    } else if let selected = overlay as? ZoneMultiPolygon {
                        if let renderer = view.renderer(for: selected) as? MKMultiPolygonRenderer {
                            if (selected.title == $selected.wrappedValue) {
                                renderer.fillColor = getZoneColor(typeId: selected.typeId, selected: true)
                            }else{
                                renderer.fillColor = getZoneColor(typeId: selected.typeId, selected: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        var gRecognizer = UITapGestureRecognizer()

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
                    self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
                    self.gRecognizer.delegate = self
                    self.parent.mapView.addGestureRecognizer(gRecognizer)
            
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if mapView.region.span.latitudeDelta > 0.008  {
                parent.zones = true
            }else {
                parent.zones = false
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { return nil }

            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }

            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.lineWidth = 1.0

            if let polygon = overlay as? ZonePolygon {
                
                let renderer = MKPolygonRenderer(overlay: overlay)
                renderer.fillColor = polygon.color
                renderer.strokeColor = polygon.borderColor
                renderer.lineWidth = 1.0
                return renderer

            } else if let polygon = overlay as? ZoneMultiPolygon {
                
                let renderer = MKMultiPolygonRenderer(overlay: overlay)
                renderer.fillColor = polygon.color
                renderer.strokeColor = polygon.borderColor
                renderer.lineWidth = 1.0

                return renderer

            } else if let layer = overlay as? ColorPolygon {
                
                let renderer = MKPolygonRenderer(overlay: overlay)
                renderer.fillColor = layer.fillColor
                renderer.strokeColor = layer.fillColor
                renderer.lineWidth = 1.0

                return renderer
                
            } else if let layer = overlay as? ColorMultiPolygon {
                
                let renderer = MKMultiPolygonRenderer(overlay: overlay)
                renderer.fillColor = layer.fillColor
                renderer.strokeColor = layer.strokeColor
                renderer.lineWidth = 1.0

                return renderer
                
            }
            return polygonRenderer
        }
        
        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
                // position on the screen, CGPoint
            let location = gRecognizer.location(in: self.parent.mapView)
                // position on the map, CLLocationCoordinate2D
                let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
                
            for prePolygon in parent.mapView.overlays {
                if let polygon = prePolygon as? ZonePolygon {
                    if polygon.contains(coordinate: coordinate) {
                        parent.selected = polygon.title
                        return
                    }
                }
                if let polygons = prePolygon as? ZoneMultiPolygon {
                    for polygon in polygons.polygons {
                        if polygon.contains(coordinate: coordinate) {
                            parent.selected = polygons.title
                            return
                        }
                    }
                }
            }
        }
    }
}
