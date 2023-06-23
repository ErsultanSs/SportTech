//
//  SportTechTerriconApp.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 21.06.2023.
//

import SwiftUI

@main
struct SportTechTerriconApp: App {
    @StateObject private var registrationState = RegistrationState()

    var body: some Scene {
        WindowGroup {
            TransitionView()
                .environmentObject(registrationState)
            
        }
    }
}
