//
//  SettitngsView.swift
//  Fun_math_game
//
//  Created by Thushini Abeysuriya on 2024-10-14.
//

import SwiftUI


struct SettingsView: View {
    @AppStorage("fontSizeDouble") var fontSizeDouble: Double = 16.0 // Store as Double
    @AppStorage("systemColorString") var systemColorString: String = "blue" // Store color as String
    @State private var fontSize: CGFloat = 16.0 // Use CGFloat in UI
    @State private var systemColor: Color = .blue // Default color
    
    var body: some View {
        NavigationView {
           Form {
                // Color Picker for changing system color
                Section(header: Text("System Color")) {
                   ColorPicker("Select a Color", selection: $systemColor)
                }
                
                // Slider for changing font size
                Section(header: Text("Font Size")) {
                    Slider(value: $fontSize, in: 12...40, step: 0.1) {
                        Text("Font Size")
                    }
                   Text("Font Size: \(fontSize, specifier: "%.1f")")
                }
            }
            .navigationBarTitle("Settings")
        }
   }
}



