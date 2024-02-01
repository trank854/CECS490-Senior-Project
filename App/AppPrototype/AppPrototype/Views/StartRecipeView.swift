//
//  StartRecipeView.swift
//  AppPrototype
//
//  Created by Andrew on 9/30/23.
//
//  Page that pops up when the user selects a recipe from the "My Recipes" Page
//

import SwiftUI

struct StartRecipeView: View {
    
    // Call Recipe Data
    var recipe: FetchedResults<Recipe>.Element
        
    var body: some View {
        // Ability to scroll through text
        ScrollView {
            VStack {
                // Display Food Name
                Text(recipe.name!)
                    .bold()
                    .padding(.bottom, 10.0)
                // Display Ingredient List
                Text("Ingredients")
                Text(recipe.ingredient!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10.0)
                // Display Instructions
                Text("Instructions")
                Text(recipe.instruction!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10.0)
                // "Start" Button to Begin Cooking the Recipe
                NavigationLink(destination: RecipeDisplayView(recipe: recipe)) {
                    Text("Start")
                        .padding(.bottom, 10.0)
                }
            }
//            // "Start" button to begin cooking
//            HStack {
//                Button("Start") {
//                }
//            }
        }
        .padding()
    }
}

// struct StartRecipeView_Previews: PreviewProvider {
//     static var previews: some View {
//         StartRecipeView()
//     }
// }
