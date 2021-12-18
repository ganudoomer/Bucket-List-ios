//
//  Result.swift
//  mapView
//
//  Created by Sree on 15/12/21.
//

import Foundation


struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable,Comparable {
    let pageid: Int
    let title: String
    let terms: [String:[String]]?
    
    var description: String{
        terms?["description"]?.first ?? "No further Information"
    }
    
    static func <(lhs: Page,rhs:Page)-> Bool {
        lhs.title < rhs.title
    }
    
    
    
}



