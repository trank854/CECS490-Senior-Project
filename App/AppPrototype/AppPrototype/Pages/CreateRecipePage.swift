//
//  CreateRecipePage.swift
//  AppPrototype
//
//  Created by Andrew on 8/28/23.
//

import SwiftUI

class FormViewModel: ObservableObject {
    @State var recipeName = ""
}

struct CreateRecipePage: View {
    
    @StateObject var viewModel = FormViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                TextField("Recipe Name", text: $viewModel.recipeName)
                    .padding(8)
                    .keyboardType(.webSearch)
                    .background(Color(.systemGray6))
                    .disableAutocorrection(true)
                    .cornerRadius(5)
                }
                
                Button(action: {
                
                }, label: {
                    Text("Continue")
                        .frame(width: 200,
                               height: 50,
                               alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                    .padding()
            }
            .padding(.bottom, 10)
            .navigationTitle("Enter Recipe Name")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateRecipePage_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipePage()
            .preferredColorScheme(.dark)
            
    }
}
