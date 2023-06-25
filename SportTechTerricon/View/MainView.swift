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
            EventsView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.fill")
                }
            
            CreateEventView()
                .tabItem {
                    Image(systemName: "plus")
                }
            
            Text("Invitation")
                .tabItem {
                    Image(systemName: "bell")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
