//
//  MathX_MobileApp.swift
//  MathX_Mobile
//
//  Created by AathithyaJ on 11/3/23.
//

import SwiftUI
import Foundation

@main
struct MathX_MobileApp: App {
    
    @State var isCalShowing = false
    @State var isCalListShowing = false

    @State var deepLinkSource = String()
    
    @AppStorage("tabSelection", store: .standard) var tabSelection = 1
    @AppStorage("isShowingWelcomeScreen", store: .standard) var isShowingWelcomeScreen = true
    
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.systemBackground
//    }

    var body: some Scene {
        WindowGroup {
            ContentView(tabSelection: $tabSelection, isCalShowing: $isCalShowing, isCalListShowing: $isCalListShowing, deepLinkSource: $deepLinkSource)
                .onOpenURL { url in
                    if !isShowingWelcomeScreen {
                        handleCalculatorDeepLink(url: url)
                    }
                }
        }
    }
    
    func handleCalculatorDeepLink(url: URL) {
        print("Asked to open URL: \(url.description)")

        guard let scheme = url.scheme,
              scheme.localizedCaseInsensitiveCompare("mathx") == .orderedSame
        else { return }

        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }

        guard url.host == "calculator", let source = parameters["source"] else { return }
        guard let sourceConverted = source.fromBase64() else { return }
        
        print(sourceConverted)
        self.deepLinkSource = source
        
        tabSelection = 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            isCalShowing = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                isCalListShowing = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
                    isCalShowing = true
                }
            }
        }
    }
}
