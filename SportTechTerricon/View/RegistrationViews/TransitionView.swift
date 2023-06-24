//
//  TransitionView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import SwiftUI

struct TransitionView: View {
    @EnvironmentObject private var registrationState: RegistrationState
    @AppStorage("RegisterTrans") var hasRegistered = false
    var body: some View {
        ZStack {
            if hasRegistered {
                MainView()
            } else {
                EntryView()
            }
        }
    }
}

struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
    }
}
