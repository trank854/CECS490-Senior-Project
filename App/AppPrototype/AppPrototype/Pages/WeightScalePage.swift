//
//  WeightScalePage.swift
//  AppPrototype
//
//  Weight Scale Page
//

import SwiftUI
import UIKit

struct WeightScalePage: View {
    
    @StateObject var service = BluetoothService()
    
    @State private var enabled = false
    @State var weightFieldText: String = ""
    @State var savedWeight: String = ""
    @State var floatWeight: Float = 0
    @State var recordedWeight: Float = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter the desired value (in oz)", text: $weightFieldText)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .foregroundColor(.red)
                    .font(.headline)
                
                Button(action: {
                    if checkNumeric(S: weightFieldText) {
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
                
                Text(savedWeight)
                // Text(String(floatWeight))
                
                // Bluetooth Weight Data Output
                Spacer()
                Text("\(service.weightValue, specifier: "%.0f")")
                    .font(.system(size: 60))
                    .foregroundColor(floatWeight < (service.weightValue + 2) && floatWeight > (service.weightValue - 2) ? .green
                                     : floatWeight <= (service.weightValue - 2) ? .red
                                     : floatWeight >= (service.weightValue + 2) ? .red
                                     : .black)
                Spacer()
                
                Text(service.peripheralStatus.rawValue)
            }
        .padding()
        .navigationTitle("Weight Scale")
        .background(Color.clear)
        }
    }
    // Checks if user input is numeric
    func checkNumeric(S: String) -> Bool {
       return Double(S) != nil
    }
    
    // Save Desired Weight Data
    func saveText() {
        savedWeight = "Desired Value (in oz): " + weightFieldText
        floatWeight = Float(weightFieldText) ?? 0
    }

}

struct WeightScalePage_Previews: PreviewProvider {
    static var previews: some View {
        WeightScalePage()
    }
}
