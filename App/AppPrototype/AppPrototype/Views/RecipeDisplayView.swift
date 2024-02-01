//
//  RecipeDisplayView.swift
//  AppPrototype
//
//  Created by Andrew on 9/30/23.
//
//  Displays recipe with the ingredient list and step-by-step instructions after user begins cooking process
//

import SwiftUI

struct RecipeDisplayView: View {
    
    // Call Recipe Data
    var recipe: FetchedResults<Recipe>.Element
    
    var body: some View {
        
        // Array created to split ingredient string by newlines, so each ingredient represents an element in the array
        let ingredients: String =  recipe.ingredient!
        let ingredientArray =  ingredients.components(separatedBy: CharacterSet.newlines)
        
        // Array created to split instruction string by newlines, so each step represents an element in the array
        let instruction: String =  recipe.instruction!
        let instructionArray =  instruction.components(separatedBy: CharacterSet.newlines)
        
        // Ability to scroll through ingredient list and steps horizontally
        ZStack {
            TabView {
                VStack {
                    // Title for Displaying Ingredient List
                    Text("Ingredients")
                        .bold()
                        .padding(.bottom, 10.0)

                    ForEach(0 ..< ingredientArray.count) { value in
                        Text(" • " + ingredientArray[value])
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Text("")
                        .bold()
                        .padding(.bottom, 10.0)
                    // Direct to "Weight Scale" Page
                    NavigationLink(destination: WeightScalePage()) {
                        Text("Weight Scale")
                            .padding(.bottom, 10.0)
                    }
                    // Direct to "Thermometer" Page
                    NavigationLink(destination: ThermometerPage()) {
                        Text("Thermometer")
                            .padding(.bottom, 10.0)
                    }
                    // Direct to "Timer" Page
                    NavigationLink(destination: TimerPage()) {
                        Text("Timer")
                            .padding(.bottom, 10.0)
                    }
                }
                
                ForEach(0 ..< instructionArray.count) { value in
                    VStack {
                        Text(instructionArray[value])
                            .padding(.bottom, 10.0)
                        // Direct to "Weight Scale" Page
                        NavigationLink(destination: WeightScalePage()) {
                            Text("Weight Scale")
                                .padding(.bottom, 10.0)
                        }
                        // Direct to "Thermometer" Page
                        NavigationLink(destination: ThermometerPage()) {
                            Text("Thermometer")
                                .padding(.bottom, 10.0)
                        }
                        // Direct to "Timer" Page
                        NavigationLink(destination: TimerPage()) {
                            Text("Timer")
                                .padding(.bottom, 10.0)
                        }
                    }
                }
                
            }
            .tabViewStyle(.page)
        }
    }
}

//struct RecipeDisplayView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeDisplayView()
//    }
//}
