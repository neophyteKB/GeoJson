//
//  MapConfigurator.swift
//  GeoJsonSample
//
//  Created by Kamal Bhardwaj on 06/07/20.
//  Copyright © 2020 Kamal Bhardwaj. All rights reserved.
//

import Foundation

class MapConfigurator {}

class MapConfiguratorImplementation: MapConfigurator {
    
    func configure(vc: MapVC) {
        let presenter = MapPresenterImplementation.init(view: vc)
        vc.presenter = presenter
    }
}
