//
//  RandView.swift
//  MathX_Mobile
//
//  Created by Tristan on 20/04/2023.
//

import SwiftUI

struct RandView: View {
    
    @State var numGenerated: [String] = []
    @State var numUnique: [Int] = []
    @State var generatedNumber = 0
    
    @State var ceilingNumber = ""
    
    @State var dataSummarySelection = 0
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("\(generatedNumber)")
                    .font(.system(size: 64))
                TextField("Max Number (Inclusive)", text: $ceilingNumber)
                    .padding()
                    .background(.ultraThickMaterial)
                    .cornerRadius(16)
                    .frame(width: UIScreen.main.bounds.width / 2)
                Spacer()
            }
            .padding(.horizontal)
            .onTapGesture {
                generateNumber()
            }
            .frame(height: (UIScreen.main.bounds.height - 120) / 2)
            
            Spacer()
            
            Divider()
            
            VStack {
                Picker("", selection: $dataSummarySelection) {
                    Text("Recent")
                        .tag(0)
                    Text("Occurences")
                        .tag(1)
                }
                .padding(.horizontal)
                .pickerStyle(.segmented)
                
                if dataSummarySelection == 0 {
                    if numGenerated.isEmpty {
                        Spacer()
                        Text("No data yet, try tapping the number to generate a random number!")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        List {
                            ForEach(numGenerated, id: \.self) { num in
                                Text(num)
                            }
                        }
                    }
                } else {
                    if numGenerated.isEmpty {
                        Spacer()
                        Text("No data yet, try tapping the number to generate a random number!")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        List {
                            ForEach(numUnique, id: \.description) { num in
                                HStack {
                                    Text(String(num))
                                    Spacer()
                                    Text("\(getOccurenceData(number: num))")
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: (UIScreen.main.bounds.height - 120) / 2)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Randomise")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    numGenerated = []
                    numUnique = []
                    generatedNumber = 0
                    ceilingNumber = ""
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    func getOccurenceData(number num: Int) -> String {
        var returnValue = ""
        
        var occurenceCount: Double = 0
        var occurencePercentage: Double = 0

        numGenerated.forEach { numg in
            if Int(numg) == num {
                occurenceCount += 1
            }
        }
        
        occurencePercentage = (occurenceCount / Double(numGenerated.count)) * 100
        
        returnValue = "\(occurenceCount.formatted())/\(numGenerated.count) (\((round(occurencePercentage * 100) / 100).formatted())%)"
        
        return returnValue
    }
    
    func generateNumber() {
        if !ceilingNumber.isEmpty {
            let generatedNumber = Int.random(in: 0...(Int(ceilingNumber) ?? 1))
            self.generatedNumber = generatedNumber
            self.numGenerated.insert(String(generatedNumber.formatted()), at: 0)
            
            if !numUnique.contains(generatedNumber) {
                numUnique.append(generatedNumber)
                numUnique = numUnique.sorted()
            }
        }
    }
}

struct RandView_Previews: PreviewProvider {
    static var previews: some View {
        RandView()
    }
}