//
//  ContentView.swift
//  UnitConvert
//
//  Created by JimmyChao on 2024/3/6.
//

import SwiftUI
import Foundation

enum CustomUnitEnum: String, CaseIterable {
    
    case length
    case area
    case angleType
    
    var unitTypes: [Dimension] {
        switch self {
        case .length:
            return [UnitLength.centimeters, UnitLength.meters, UnitLength.kilometers]
        case .area:
            return [UnitArea.squareCentimeters, UnitArea.squareMeters, UnitArea.squareKilometers]
        case .angleType:
            return [UnitAngle.arcMinutes, UnitAngle.radians, UnitAngle.gradians]
        }
    }
}

struct ContentView: View {
    
    @State var inputValue: Double = 0
    @State var unitTypeToConvertFrom: Dimension = UnitLength.meters
    @State var unitTypeToConvertTo: Dimension = UnitLength.centimeters
    
    @State var selectedUnitTypes: CustomUnitEnum = .length
    
    private var resultValue: String {
        let inputMeasurement = Measurement(
            value: inputValue,
            unit: unitTypeToConvertFrom)
        
        let result = inputMeasurement.converted(to: unitTypeToConvertTo).formatted(.measurement(width: .abbreviated))
        
        return result
    }
    
    private var inputUnitSymbol: String {
        unitTypeToConvertFrom.symbol
    }
    
    private func setDefaultSelection() {
        unitTypeToConvertFrom = selectedUnitTypes.unitTypes.first ?? unitTypeToConvertFrom
        unitTypeToConvertTo = selectedUnitTypes.unitTypes.last ?? unitTypeToConvertTo
    }
    
    var body: some View {
        
        VStack {
            Form {
                // Section one for input
                Section {
                    // let inputMeasurement = Measurement(value: inputValue, unit: unitTypeToConvertFrom)
                    TextField("Input the value in \(unitTypeToConvertFrom.symbol.lowercased())", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .onAppear {
                            setDefaultSelection()
                        }
                }
                
                // Section two for choosing parameter
                Section {
                    Picker("Please choose a unit type", selection: $selectedUnitTypes) {
                        ForEach(CustomUnitEnum.allCases, id: \.self) {
                            Text("\($0.rawValue)")
                        }
                    }
                    
                    Picker("Please choose a unit type you want to convert from", selection: $unitTypeToConvertFrom) {
                        ForEach(selectedUnitTypes.unitTypes, id: \.self) {
                            Text($0.symbol.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    
                    Picker("Please choose a unit type you want to convert to", selection: $unitTypeToConvertTo) {
                        ForEach(selectedUnitTypes.unitTypes, id: \.self) {
                            Text($0.symbol.capitalized)
                        }
                    }.pickerStyle(.segmented)
                }
                
                // Section three for showing result
                Section("Output result") {
                    Text(resultValue)
                }
            }
            .onChange(of: selectedUnitTypes) {
                setDefaultSelection()
            }
        }
    }
}

#Preview {
    ContentView()
}
