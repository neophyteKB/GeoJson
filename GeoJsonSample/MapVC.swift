//
//  MapVC.swift
//  GeoJsonSample
//
//  Created by Kamal Bhardwaj on 05/07/20.
//  Copyright © 2020 Kamal Bhardwaj. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MainView {
    
    var presenter: MapPresenter!
    var configurator = MapConfiguratorImplementation.init()
    var tableViewController: UITableViewController?
    
    private var mapView: MKMapView!
    private var centerCoordinate = CLLocationCoordinate2D.init(latitude: 76.7794, longitude: 30.7333)
    private var polygonInfo: PolygonInfo?
    private var polylineInfo: PolylineInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.configurator.configure(vc: self)
        self.presenter.viewDidLoad()
    }
}

//MARK: ==> MainView Delegate Methods
extension MapVC {
    func setUpMapView() {
        self.mapView = MKMapView.init(frame: UIScreen.main.bounds)
        let region = MKCoordinateRegion.init(center: self.centerCoordinate,
                                             latitudinalMeters: CLLocationDistance.init(500),
                                             longitudinalMeters: CLLocationDistance.init(500))
        self.mapView.setRegion(region, animated: true)
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self
    }
    
    func setAnnotations(annotations: [MKAnnotation]) {
        self.mapView.addAnnotations(annotations)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func animateMap(to coordinates: CLLocationCoordinate2D) {
        self.mapView.setCenter(coordinates, animated: true)
    }
    
    func render(overlay: MKOverlay, info: Any?) {
        if let polygonInfo = info as? PolygonInfo {
            self.polygonInfo = polygonInfo
        }
        else if let polylineInfo = info as? PolylineInfo {
            self.polylineInfo = polylineInfo
        }
        self.mapView.addOverlay(overlay)
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.lineWidth = CGFloat(self.polygonInfo?.strokeWidth ?? 2)
            polygonView.fillColor = (self.polygonInfo?.fill?.color() ?? UIColor.green).withAlphaComponent(0.25)
            polygonView.strokeColor = self.polygonInfo?.stroke?.color() ?? UIColor.init(white: 0, alpha: 0.5)
            return polygonView
        }
        else if overlay is MKPolyline {
            let polylineView = MKPolylineRenderer(overlay: overlay)
            polylineView.lineWidth = CGFloat(self.polylineInfo?.strokeWidth ?? 2)
            polylineView.strokeColor = self.polylineInfo?.stroke?.color() ?? UIColor.red
            polylineView.lineCap = .round
            return polylineView
        }
        return MKOverlayRenderer.init()
    }
}

