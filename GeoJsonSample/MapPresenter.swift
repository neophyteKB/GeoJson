//
//  MapPresenter.swift
//  GeoJsonSample
//
//  Created by Kamal Bhardwaj on 05/07/20.
//  Copyright © 2020 Kamal Bhardwaj. All rights reserved.
//

import Foundation
import MapKit

protocol MainView {
    func setUpMapView()
    func animateMap(to coordinates: CLLocationCoordinate2D)
    func setAnnotations(annotations: [MKAnnotation])
    func render(overlay: MKOverlay)
}

protocol MapPresenter {
    func viewDidLoad()
}

class MapPresenterImplementation: MapPresenter {
    
    private var view: MainView?
    private var geometry: [MKShape & MKGeoJSONObject]!
    private var properties: Data?
    
    init(view: MainView) {
        self.view = view
    }
    
    func viewDidLoad() {
        self.view?.setUpMapView()
        self.fetchJson()
    }
    
    private func fetchJson() {
        guard let geoJsonFileUrl = Bundle.main.url(forResource: "location", withExtension: "geojson"),
            let geoJsonData = try? Data.init(contentsOf: geoJsonFileUrl) else {
                fatalError("Failure to fetch the file.")
        }
        /*
         1. geoJsonData is data type
         **/
        guard let objs = try? MKGeoJSONDecoder().decode(geoJsonData) as? [MKGeoJSONFeature] else {
            fatalError("Wrong format")
        }
        objs.forEach { (feature) in
            guard let geometry = feature.geometry.first,
                let propData = feature.properties else {
                return;
            }
            let info = try? JSONDecoder.init().decode(Info.self, from: propData)
            self.view?.animateMap(to: geometry.coordinate)
            
            if let polygon = geometry as? MKPolygon {
                self.view?.render(overlay: polygon)
                self.fetchPolygonCoordinates(polygon: polygon)
            }
            if let polyline = geometry as? MKPolyline {
                self.view?.render(overlay: polyline)
            }
            if let annotation = geometry as? MKPointAnnotation {
                let storeAnnotation = StoreAnnotation.init(title: info?.name,
                                                           subtitle: info?.subTitle,
                                                           website: info?.website,
                                                           coordinate: annotation.coordinate)
                self.view?.setAnnotations(annotations: [storeAnnotation])
            }
        }
    }
    
    private func fetchPolygonCoordinates(polygon: MKPolygon) {
        
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: polygon.pointCount)
        polygon.getCoordinates(&coords,
                               range: NSRange.init(location: 0, length: polygon.pointCount))
        var annotations = [MKPointAnnotation]()
        for coordinate in coords {
            let annotation = MKPointAnnotation.init()
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
        self.view?.setAnnotations(annotations: annotations)
    }
}
