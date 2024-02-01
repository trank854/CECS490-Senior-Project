//
//  DataController.swift
//  AppPrototype
//
//  Created by Andrew on 9/4/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    // Responsible for preparing a model
    let container = NSPersistentContainer(name: "RecipeModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
    }
    
    // Function to save data
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            // Handle errors in our database
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // Function to add recipe
    func addRecipe(name: String, ingredient: String, instruction: String, context: NSManagedObjectContext) {
        let recipe = Recipe(context: context)
        recipe.id = UUID()
        recipe.date = Date()
        recipe.name = name
        recipe.ingredient = ingredient
        recipe.instruction = instruction
        save(context: context)
    }
    
    // Function to edit recipe
    func editRecipe(recipe: Recipe, name: String, ingredient: String, instruction: String, context: NSManagedObjectContext) {
        recipe.date = Date()
        recipe.name = name
        recipe.ingredient = ingredient
        recipe.instruction = instruction
        
        save(context: context)
    }
}
