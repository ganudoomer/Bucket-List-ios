//
//  ContentView-ViewModel.swift
//  mapView
//
//  Created by Sree on 18/12/21.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    @MainActor  class ViewModel: ObservableObject {
        
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations : [Location]
        @Published  var selecteLocation: Location?
        @Published  var isUnlocked = false
        
        let savePath = FileManager.doucmentsDir.appendingPathComponent("SavedPlaces")
        
        
        init() {
            do{
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                print("Unable to load data")
                locations = []
            }
        }
        
        func save(){
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath,options: [.atomic,.completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        
        func addLocation(){
            let newLocation = Location(id: UUID(), longitude:mapRegion.center.longitude, latiude: mapRegion.center.latitude, name: "New Location", description: "")
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let place = selecteLocation else  { return }
            if let index = locations.firstIndex(of: place) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ succss, authenticationError in
                    if succss {
                        Task { @MainActor in
//                            await MainActor.run {
                                self.isUnlocked = true
//                            }
                        }
                      
                    } else {
                        // Error
                    }
                }
            } else {
                // No Bio
            }
            
            
        }
        
    }
    
    
    
}


