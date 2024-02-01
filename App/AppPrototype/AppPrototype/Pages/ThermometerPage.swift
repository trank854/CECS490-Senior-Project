//
//  ThermometerPage.swift
//  AppPrototype
//
//  Thermometer Page
//

import SwiftUI
import UIKit

struct ThermometerPage: View {
    
    @StateObject var service = BluetoothService()
    
    @State var tempFieldText: String = ""
    @State var savedTemp: String = ""
    @State var floatTemp: Float = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter the desired value (in F)", text: $tempFieldText)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .foregroundColor(.red)
                    .font(.headline)
                
                Button(action: {
                    if checkNumeric(S: tempFieldText) {
                        saveText()
                    }
                }, label: {
                    Text("Enter".uppercased())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.cornerRadius(10))
                        .foregroundColor(.white)
                        .font(.headline)
                })
                
                Text(savedTemp)
                // Text(String(floatTemp))
                
                // Bluetooth Temperature Data Output
                Spacer()
                Text("\(service.therValue, specifier: "%.0f")")
                    .font(.system(size: 60))
                    .foregroundColor(floatTemp < (service.therValue + 6) && floatTemp > (service.therValue - 6) ? .green
                                     : floatTemp <= (service.therValue - 6) ? .red
                                     : floatTemp >= (service.therValue + 6) ? .red
                                     : .black)
                Spacer()
                
                Text(service.peripheralStatus.rawValue)
            }
            .padding()
            .navigationTitle("Thermometer")
        }
    }
    // Checks if user input is numeric
    func checkNumeric(S: String) -> Bool {
       return Double(S) != nil
    }
    
    // Save Desired Temperature Data
    func saveText() {
        savedTemp = "Desired Value (in F): " + tempFieldText
        floatTemp = Float(tempFieldText) ?? 0
    }
    
}

struct ThermometerPage_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerPage()
    }
}
