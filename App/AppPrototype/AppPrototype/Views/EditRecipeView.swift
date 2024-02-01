//
//  EditRecipeView.swift
//  AppPrototype
//
//  Created by Andrew on 9/4/23.
//

import SwiftUI

struct EditRecipeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var recipe: FetchedResults<Recipe>.Element
    
    // Declare variables
    @State private var name = ""
    @State private var ingredient = ""
    @State private var instruction = ""
    
    var body: some View {
        Form {
            Section() {
                // Edit recipe name
                TextField("\(recipe.name!)", text: $name)
                    .onAppear {
                        name = recipe.name!
                    }
                
                VStack {
                    // Edit ingredient list
                    Text("Ingredient List")
                    TextEditor(text: $ingredient)
                        .onAppear {
                            ingredient = recipe.ingredient!
                        }
                        .frame(height: 125)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.2), lineWidth: 4)
                        )
                    // Edit instruction list
                    Text("Instruction")
                    TextEditor(text: $instruction)
                        .onAppear {
                            instruction = recipe.instruction!
                        }
                        .frame(height: 125)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.2), lineWidth: 4)
                        )
                }
                .padding()
                
                // Submit button
                HStack {
                    Spacer()
                    Button("Submit") {
                        DataController().editRecipe(recipe: recipe, name: name, ingredient: ingredient, instruction: instruction, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}
