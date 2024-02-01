//
//  SettingsPage.swift
//  AppPrototype
//
//  Created by Andrew on 9/11/23.
//

import SwiftUI

struct SettingsPage: View {
    
    @StateObject var service = BluetoothService()
    
    @Binding var darkModeEnabled: Bool
    @Binding var systemThemeEnabled: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section (header: Text("Display"),
                             footer: Text("System settings will override Dark Mode and use the current device theme")) {
                        Toggle (isOn: $darkModeEnabled, label: {Text("Dark Mode")})
                            .onChange(of: darkModeEnabled, perform: { _ in SystemThemeManager .shared .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)})
                        Toggle (isOn: $systemThemeEnabled, label: {Text("Use System Settings")})
                            .onChange(of: systemThemeEnabled, perform: { _ in SystemThemeManager .shared .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)})
                    }
                    .foregroundColor(Theme.textColor)

                }
                Text(service.peripheralStatus.rawValue)
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage(darkModeEnabled: .constant(false),
        systemThemeEnabled: .constant(false))
    }
}
