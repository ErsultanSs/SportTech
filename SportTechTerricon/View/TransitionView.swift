//
//  TransitionView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import SwiftUI

struct TransitionView: View {
    @EnvironmentObject private var registrationState: RegistrationState
    var body: some View {
        ZStack {
            if registrationState.isRegistered {
                MainView()
            } else {
                RegistrationView()
            }
        }
    }
}

struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
    }
}
