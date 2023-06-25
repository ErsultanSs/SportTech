//
//  PayView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 25.06.2023.
//

import SwiftUI

struct PayView: View {
    var value: Double
    var eventId: Int
    @State var showAlert = false
    @Environment(\.self) var env

    
    var body: some View {
        VStack {
            Text("\(Int(value))тг")
                .font(.largeTitle)
            
            
            Button {
                showAlert = true
                APIRequest.shared.pay(eventId: eventId, value: value) { result in
                    switch result {
                    case .success(_):
                        print("")
                    case .failure(_):
                        print("")
                    }
                }
                env.dismiss()
            } label: {
                Text("Pay")
                    .foregroundColor(.green)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Successfully paid"))
        }
    }
}


