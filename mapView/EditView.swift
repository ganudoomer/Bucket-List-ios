//
//  EditView.swift
//  mapView
//
//  Created by Sree on 14/12/21.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading,loaded,failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    @State private var  name: String
    @State private var  description: String
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    var onSave: (Location)->Void
    
    
    init(location: Location, onSave: @escaping (Location)->Void){
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name",text: $name)
                    TextField("Description",text: $description)
                }
                Section("Near by...") {
                    switch loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(pages,id:\.pageid){ page in
                            Text("\(page.title)").font(.headline)
                            + Text(":") + Text(page.description).italic()
                        }
                    case .failed:
                        Text("Please try again later")
                    }
                }
                
            }.navigationTitle("Details").toolbar {
                Button("Save") {
                    var newLoaction = location
                    newLoaction.id = UUID()
                    newLoaction.name = name
                    newLoaction.description = description
                    onSave(newLoaction)
                    dismiss()
                }
            }.task{
                await fetchRequest()
            }
        }
    }
    
    func fetchRequest() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latiude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"


        guard let url = URL(string:urlString) else {
            print("Bad Url \(urlString)")
            return  }
        
        do {
            let (data,_) = try await URLSession.shared.data(from:url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            
            pages = items.query.pages.values.sorted()
            loadingState = LoadingState.loaded
            
        } catch {
            loadingState = LoadingState.failed
            print("Cool")
        }
        
        
    }
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
