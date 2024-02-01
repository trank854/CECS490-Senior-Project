//
//  AddRecipeView.swift
//  AppPrototype
//
//  Created by Andrew on 9/4/23.
//
//  "Create Recipe" Page for Creating and Saving Custom Recipes
//

import SwiftUI

@available(iOS 14.0, *)
extension EnvironmentValues {
    var dismiss: () -> Void {
        { presentationMode.wrappedValue.dismiss() }
    }
}

struct AddRecipeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    // Declare Variables
    @State private var name = ""
    @State private var ingredient = ""
    @State private var instruction = ""
    @State private var recipeCount: Int16 = 0
    
    // Prompts user to add recipe name and ingredient list for creating new recipe
    var body: some View {
        Form {
            Section() {
                TextField("Food name", text: $name)
                
                VStack {
                    Text("Ingredient List")
                    TextEditor(text: $ingredient)
                            .frame(height: 125)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray.opacity(0.2), lineWidth: 4)
                            )
                    Text("Instructions")
                    TextEditor(text: $instruction)
                            .frame(height: 125)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray.opacity(0.2), lineWidth: 4)
                            )
                }
                .padding()
                HStack {
                    Spacer()
                    Button("Submit") {
                        recipeCount += 1
                        DataController().addRecipe(
                            name: name, ingredient: ingredient, instruction: instruction,
                            context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}

//private extension AddRecipeView {
//    var textEditorVw: some View {
//        TextEditor(text: $ingredient)
//            .frame(height: 125)
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(.gray.opacity(0.2), lineWidth: 4)
//            )
//    }
//
//    var descriptionTxtVw: some View {
//        Text("Ingredient List")
//    }
    
    
    
    
// }
