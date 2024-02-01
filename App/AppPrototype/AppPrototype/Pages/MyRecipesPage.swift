//
//  MyRecipesPage.swift
//  AppPrototype
//
//  Created by Andrew on 8/30/23.
//
// "My Recipes" Page to Display Saved Custom Recipes
//

import SwiftUI
import CoreData

struct MyRecipesPage: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var recipe: FetchedResults<Recipe>
    
    @State private var showingAddView = false
    
    
    var body: some View {
        // Back Navigation
        VStack {
            Spacer()
                .navigationBarBackButtonHidden(true)
                .toolbar(content: {
                    ToolbarItem (placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                      //  Image(systemName: "arrow.left")
                        Image(systemName: "house")
                        .foregroundColor(.blue)
                    })
                    }
                })
        }
        Spacer()
        NavigationView {
            VStack (alignment: .leading) {
                List {
                    // Recipe in List
                    ForEach(recipe) { recipe in
                        NavigationLink(destination: StartRecipeView(recipe: recipe)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(recipe.name!)
                                        .bold()
                                }
                                Spacer()
                                Text(calcTimeSince(date: recipe.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteRecipe)
                }
                .listStyle(.plain)
            }
            // "My Recipes" Navigation Title
            .navigationTitle("My Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddRecipeView()
            }
        }
        .navigationViewStyle(.stack) // Removes sidebar on iPad
    }
    
    // Deletes recipe at the current offset
    private func deleteRecipe(offsets: IndexSet) {
        withAnimation {
            offsets.map { recipe[$0] }
            .forEach(managedObjContext.delete)
            
            // Saves to our database
            DataController().save(context: managedObjContext)
        }
    }
    
    
    
    
}

struct MyRecipesPage_Previews: PreviewProvider {
    static var previews: some View {
        MyRecipesPage()
    }
}
