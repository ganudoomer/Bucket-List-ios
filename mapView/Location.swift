//
//  Location.swift
//  mapView
//
//  Created by Sree on 14/12/21.
//

import Foundation
import CoreLocation


struct Location: Identifiable,Codable,Equatable {
    var id: UUID
    let longitude: Double
    let latiude: Double
    var name: String
    var description: String
    
    
    var cooridinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latiude, longitude: longitude)
    }
    
    static let example = Location(id: UUID(), longitude: 51.501, latiude: -0.141, name: "BK place", description: "Where the queen is theere")
    
    static func ==(lhs: Location,rhs: Location)-> Bool {
        lhs.id == rhs.id
    }
    
}
