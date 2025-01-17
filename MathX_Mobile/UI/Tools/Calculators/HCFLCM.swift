import SwiftUI

struct HCF_LCM_CalculatorView: View  {
    
    @State var position: CGRect = .zero
    
    @State var lhsNumber: Int
    @State var rhsNumber: Int
    
    @State var showOnlyPrime: Bool = false
    
    @State var HCFLCMSelection = 0
    @State var stateHCFLCMSelection = 0

    var lhsFactors: [Int] { factors(of: lhsNumber) }
    var rhsFactors: [Int] { factors(of: rhsNumber) }
    
    var commonFactors: [Int] {
        var leftIndex = 0
        var rightIndex = 0
        var factors = [Int]()
        
        let lhs = lhsFactors
        let rhs = rhsFactors
        
        while leftIndex < lhs.count && rightIndex < rhs.count {
            let left = lhs[leftIndex]
            let right = rhs[rightIndex]
            if left == right {
                factors.append(left)
            }
            if left <= right {
                leftIndex += 1
            } else if right <= left {
                rightIndex += 1
            }
        }
        
        return factors
    }
    
    @State var leadingOffset: CGFloat = 0
    @State var trailingOffset: CGFloat = 0
    
    @State var leadingStartOffset: CGFloat?
    @State var trailingStartOffset: CGFloat?
    
    var body: some View {
        VStack {
            Form {
                Picker("", selection: $HCFLCMSelection) {
                    Text("HCF")
                        .tag(0)
                    Text("LCM")
                        .tag(1)
                }
                .pickerStyle(.segmented)
                .onChange(of: HCFLCMSelection) { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        stateHCFLCMSelection = HCFLCMSelection
                    }
                }
                
                if HCFLCMSelection == 0 {
                    
                    //            Text("""
                    //                minX: \(position.minX)
                    //                maxX: \(position.maxX)
                    //                minY: \(position.minY)
                    //                maxY: \(position.maxY)
                    //                common: \(commonFactors.description)
                    //            """)
                    
                    Section {
                        TextField("First Number", text: .init(get: { lhsNumber.description },
                                                              set: { lhsNumber = Int($0) ?? 0 }))
                        .keyboardType(.numberPad)
                        TextField("Second Number", text: .init(get: { rhsNumber.description },
                                                               set: { rhsNumber = Int($0) ?? 0 }))
                        .keyboardType(.numberPad)
                        
                        Toggle("Only show prime numbers", isOn: .init(get: {
                            showOnlyPrime
                        }, set: { newValue in
                            withAnimation {
                                showOnlyPrime = newValue
                            }
                        }))
                        .disabled(lhsNumber <= 0 && rhsNumber <= 0)
                        .onChange(of: lhsNumber) { _ in
                            if lhsNumber <= 0 && rhsNumber <= 0 {
                                showOnlyPrime = false
                            }
                        }
                        .onChange(of: rhsNumber) { _ in
                            if lhsNumber <= 0 && rhsNumber <= 0 {
                                showOnlyPrime = false
                            }
                        }
                    }
                    
                    if lhsNumber > 0 || rhsNumber > 0 {
                        Section(header: Text("Results")) {
                            HStack(alignment: .top) {
                                ribbonComponent
                            }
                            .background {
                                GeometryReader { geom in
                                    Color.clear
                                        .onAppear {
                                            position = geom.frame(in: .named("listCoordinate"))
                                        }
                                        .onChange(of: geom.frame(in: .named("listCoordinate"))) { newValue in
                                            position = newValue
                                        }
                                }
                            }
                        }
                    } else {
                        Section(header: Text("Results")) {
                            HStack(alignment: .top) {
                                VStack {
                                    Text("0")
                                        .frame(height: 30)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, -4)
                                }
                                VStack {
                                    Text("0")
                                        .frame(height: 30)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, -4)
                                }
                            }
                        }
                    }
                } else {
                    OldHCF_LCM_CalculatorView(isHCFSelected: $HCFLCMSelection)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .coordinateSpace(name: "listCoordinate")
        }
        .navigationTitle("HCF & LCM Calculator")
    }
    
    @Namespace var namespace
    
    @ViewBuilder
    var ribbonComponent: some View {
        factorView(factors: lhsFactors)
        Color.clear
            .overlay {
                ForEach(commonFactors, id: \.self) { factor in
                    BezierRectangle(leadingY: 30*CGFloat(lhsFactors.firstIndex(of: factor)!) + leadingOffset,
                                    leadingHeight: 30,
                                    trailingY: 30*CGFloat(rhsFactors.firstIndex(of: factor)!) + trailingOffset,
                                    trailingHeight: 30)
                    .fill(Color.accentColor.opacity(0.5))
                    .opacity((showOnlyPrime ? factor.isPrime : true) ? 1 : 0)
                }
            }
            .padding(.horizontal, -8)
            .padding(.vertical, -4)
        factorView(factors: rhsFactors)
    }
    
    func factorView(factors: [Int]) -> some View {
        VStack {
            let common = commonFactors
            ForEach(factors, id: \.self) { index in
                Text(index.description)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background {
                        if common.contains(index) {
                            Color.accentColor.opacity(0.5)
                        }
                    }
                    .padding(.vertical, -4)
                    .opacity((showOnlyPrime ? index.isPrime : true) ? 1 : 0)
            }
        }
    }
    
    func factors(of n: Int) -> [Int] {
        guard n > 0 else { return [] }
        let sqrtn = Int(Double(n).squareRoot())
        var factors: [Int] = []
        factors.reserveCapacity(2 * sqrtn)
        for i in 1...sqrtn {
            if n % i == 0 {
                factors.append(i)
            }
        }
        var j = factors.count - 1
        if factors[j] * factors[j] == n {
            j -= 1
        }
        while j >= 0 {
            factors.append(n / factors[j])
            j -= 1
        }
        return factors
    }
}

struct HCF_LCM_CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        HCF_LCM_CalculatorView(lhsNumber: 128, rhsNumber: 570)
    }
}

extension Int {
    var isPrime: Bool {
        guard self >= 2     else { return false }
        guard self != 2     else { return true  }
        guard self % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
    }
}

struct BezierRectangle: Shape {
    var leadingY: CGFloat
    var leadingHeight: CGFloat
    
    var trailingY: CGFloat
    var trailingHeight: CGFloat
    
    struct BezierRectangleAnimatableData {
        var leadingY: CGFloat
        var leadingHeight: CGFloat
        
        var trailingY: CGFloat
        var trailingHeight: CGFloat
    }
    
    var animatableData: BezierRectangleAnimatableData {
        get {
            .init(leadingY: leadingY,
                  leadingHeight: leadingHeight,
                  trailingY: trailingY,
                  trailingHeight: trailingHeight)
        }
        set {
            self.leadingY = newValue.leadingY
            self.leadingHeight = newValue.leadingHeight
            self.trailingY = newValue.trailingY
            self.trailingHeight = newValue.trailingHeight
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // left side
        path.move(to: .init(x: rect.minX, y: rect.minY + leadingY))
        path.addLine(to: .init(x: rect.minX, y: rect.minY + leadingY + leadingHeight))
        
        let closerToLeading: CGFloat = rect.midX
        let closerToTrailing: CGFloat = rect.midX
        
        // (bottom) left to right bridge
        path.addCurve(to: .init(x: rect.maxX,
                                y: rect.minY + trailingY + trailingHeight),
                      control1: .init(x: closerToLeading,
                                      y: rect.minY + leadingY + leadingHeight),   // about 1/3 way
                      control2: .init(x: closerToTrailing,
                                      y: rect.minY + trailingY + trailingHeight)) // about 2/3 way
        
        // right side
        path.addLine(to: .init(x: rect.maxX, y: rect.minY + trailingY))
        
        // (top) right to left bridge
        path.addCurve(to: .init(x: rect.minX,
                                y: rect.minY + leadingY),
                      control1: .init(x: closerToTrailing,
                                      y: rect.minY + trailingY), // about 2/3 way
                      control2: .init(x: closerToLeading,
                                      y: rect.minY + leadingY))  // about 1/3 way
        
        return path
    }
}

struct OldHCF_LCM_CalculatorView: View {
    
    @State private var number1 = ""
    @State private var number2 = ""
    @State private var result = ""
    @Binding var isHCFSelected: Int
    
    @FocusState var number1Focused: Bool
    @FocusState var number2Focused: Bool
    
    var body: some View {
        Section {
            TextField("First number", text: $number1)
                .keyboardType(.decimalPad)
                .focused($number1Focused)
            
            TextField("Second number", text: $number2)
                .keyboardType(.decimalPad)
                .focused($number2Focused)
        }
        
        Section(header: Text("Results")) {
            HStack {
                Text("LCM:")
                Spacer()
                Text("\(result)")
                    .multilineTextAlignment(.trailing)
            }
        }
        .onChange(of: number1) { _ in
            if number1.count > 7 {
                number1.removeLast()
            } else {
                self.calculate()
            }
        }
        .onChange(of: number2) { _ in
            if number2.count > 7 {
                number2.removeLast()
            } else {
                self.calculate()
            }
        }
        .onAppear {
            self.calculate()
        }
    }
    
    func calculate() {
        guard let num1 = Double(number1), let num2 = Double(number2) else {
            self.result = ""
            return
        }
        
        let gcd = findGCD(Int(num1 * 100), Int(num2 * 100))
        let lcm = Int(num1 * 100 * num2 * 100) / gcd
        
        if isHCFSelected == 0  {
            self.result = String((Double(gcd) / 100).formatted())
        } else {
            self.result = String((Double(lcm) / 100).formatted())
        }
    }
    
    func findGCD(_ num1: Int, _ num2: Int) -> Int {
        if num2 == 0 {
            return num1
        } else {
            return findGCD(num2, num1 % num2)
        }
    }
}

//struct OldHCF_LCM_CalculatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        OldHCF_LCM_CalculatorView()
//    }
//}
