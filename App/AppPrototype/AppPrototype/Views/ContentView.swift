//
//  ContentView.swift
//  AppPrototype
//
//  Created by Andrew on 7/30/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false;
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false;
    
    var body: some View {
        NavigationView {
            // Menu Display
            VStack {
                Text("Remy the Rat")
                    .bold()
                    .padding(.bottom, 10.0)
                Image("ratlogo")
                    .padding(.bottom, 10.0)
                    .imageScale(.small)
                // Direct to "Create Recipe" Page
                NavigationLink(destination: AddRecipeView()) {
                    Text("Create Recipe")
                        .padding(.bottom, 10.0)
                }
                // Direct to "My Recipes" Page
                NavigationLink(destination: MyRecipesPage()) {
                    Text("My Recipes")
                        .padding(.bottom, 10.0)
                }
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
                // Direct to "Settings" Page
                NavigationLink(destination: SettingsPage(darkModeEnabled: $darkModeEnabled, systemThemeEnabled: $systemThemeEnabled)) {
                    Text("Settings")
                        .padding(.bottom, 10.0)
                }
            }
        }
        .padding()
        .onAppear{
            SystemThemeManager
                .shared
                .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
