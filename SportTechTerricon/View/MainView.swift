//
//  MainView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var registrationState: RegistrationState

    var body: some View {
        TabView {
            Text("Hello")
                .tabItem {
                    Image(systemName: "globe")
                }
            
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
