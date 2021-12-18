//
//  ContentView.swift
//  mapView
//
//  Created by Sree on 14/12/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
   @StateObject private var viewModel = ViewModel()
    
    
    var body: some View {
        if viewModel.isUnlocked {
            
       
        ZStack{
            Map(coordinateRegion: $viewModel.mapRegion,annotationItems: viewModel.locations){ locaiton in
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
                        viewModel.selecteLocation = locaiton
                    }
                }
                
            }.ignoresSafeArea()
            Circle().fill(.blue).opacity(0.3).frame(width: 35, height: 35)
            VStack{
             Spacer()
                HStack{
                    Spacer()
                    Button {
                        viewModel.addLocation()
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
        }.sheet(item: $viewModel.selecteLocation) { place in
            EditView(location: place) { location in
                viewModel.updateLocation(location: location)
            }
        }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }.padding().background(.blue).foregroundColor(.white).clipShape(Capsule())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
