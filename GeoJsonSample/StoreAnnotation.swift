//
//  StoreAnnotation.swift
//  GeoJsonSample
//
//  Created by Kamal Bhardwaj on 06/07/20.
//  Copyright © 2020 Kamal Bhardwaj. All rights reserved.
//

import Foundation
import MapKit

class StoreAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let website: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, website: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.website = website
        self.coordinate = coordinate
    }
}


// MARK: - Info
struct Info: Codable {
    let name, subTitle: String
    let website: String
}
