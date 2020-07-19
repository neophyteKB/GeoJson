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

class StoreOverlay: MKOverlayRenderer {
    let title: String?
    let subtitle: String?
    let strokeColor: UIColor
    let fillColor: UIColor
    let stroke: Int
    
    init(title: String?, subTitle: String?, overlay: MKOverlay, strokeColor: String?, fillColor: String?, strokeWidth: Int) {
        self.title = title
        self.subtitle = subTitle
        self.strokeColor = strokeColor?.color() ?? .red
        self.fillColor = (fillColor?.color() ?? .red).withAlphaComponent(0.25)
        self.stroke = strokeWidth
        super.init(overlay: overlay)
    }
}


// MARK: - Info
struct Info: Codable {
    let name, subTitle: String
    let website: String
}
struct PolygonInfo: Codable {
    let stroke: String?
    let strokeWidth, strokeOpacity: Int?
    let fill: String?
    let fillOpacity: Double?
    let title, subtitle: String?
}

struct PolylineInfo: Codable {
    let stroke: String?
    let strokeWidth, strokeOpacity: Int?
    let title, subtitle: String?
}

private enum CodingKeys: String, CodingKey {
    case stroke
    case strokeWidth = "stroke-width"
    case strokeOpacity = "stroke-opacity"
    case fill
    case fillOpacity = "fill-opacity"
    case title, subtitle
}

extension String {
    func color() -> UIColor {
        var color: UIColor = UIColor.init()
        let r, g, b, a: CGFloat

        if self.hasPrefix("#") {
            let start = self.index(self.startIndex, offsetBy: 1)
            var hexColor = String(self[start...])
            
            if hexColor.count == 6 {
                hexColor.append("ff")
            }
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                color = UIColor.init(red: r, green: g, blue: b, alpha: a)
            }
        }
        return color
    }
}
