//
//  FileManager-DocumentsDirectory .swift
//  mapView
//
//  Created by Sree on 18/12/21.
//

import Foundation



extension FileManager {
    static var doucmentsDir : URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
