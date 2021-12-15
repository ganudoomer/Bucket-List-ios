//
//  ContentView.swift
//  mapView
//
//  Created by Sree on 14/12/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    @State private var  locations = [Location]()
    @State private var  selecteLocation: Location?
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapRegion,annotationItems: locations){ locaiton in
                MapAnnotation(coordinate: locaiton.cooridinate){
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                            
                        Text(locaiton.name).fixedSize()
                    }.onTapGesture {
                        selecteLocation = locaiton
                    }
                }
                
            }.ignoresSafeArea()
            Circle().fill(.blue).opacity(0.3).frame(width: 35, height: 35)
            VStack{
             Spacer()
                HStack{
                    Spacer()
                    Button {
                        let newLocation = Location(id: UUID(), longitude: mapRegion.center.longitude, latiude: mapRegion.center.latitude, name: "New Location", description: "")
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }.padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                }
        
            }
        }.sheet(item: $selecteLocation) { place in
            EditView(location: place) { location in
             if let index = locations.firstIndex(of: place) {
                    locations[index] = location
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
