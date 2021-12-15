//
//  EditView.swift
//  mapView
//
//  Created by Sree on 14/12/21.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    @State private var  name: String
    @State private var  description: String
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
            }.navigationTitle("Details").toolbar {
                Button("Save") {
                    var newLoaction = location
                    newLoaction.id = UUID()
                    newLoaction.name = name
                    newLoaction.description = description
                    onSave(newLoaction)
                    dismiss()
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
