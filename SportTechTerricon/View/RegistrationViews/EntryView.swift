//
//  EntryView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 24.06.2023.
//

import SwiftUI

struct EntryView: View {
    @State private var isRegistering = false
    
    var body: some View {
        if isRegistering {
            RegistrationView()
                .transition(.move(edge: .trailing))
        } else {
            LoginView()
                .transition(.move(edge: .leading))
        }
        
        Button(action: {
            isRegistering.toggle()
        }) {
            Text(isRegistering ? "Already have an account? Login" : "Don't have an account? Register")
                .foregroundColor(.blue)
                .padding(.top, 10)
        }
        .offset(y: 350)
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}

