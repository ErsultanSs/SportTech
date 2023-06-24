//
//  ProfileView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import SwiftUI

struct ProfileView: View {
    @State var firstname = ""
    @State var lastname = ""
    @State var email = ""
    
    @AppStorage("RegisterTrans") var hasRegistered = false

    var body: some View {
        VStack {
            Text("Profile")
                .font(.title)
                .bold()
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                ProfileInfoRow(title: "First Name", value: firstname)
                ProfileInfoRow(title: "Last Name", value: lastname)
                ProfileInfoRow(title: "Email", value: email)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Settings")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                // Add your settings components here
                Toggle("Notification", isOn: .constant(true))
                    .padding(.top, 5)
                
                Toggle("Dark Mode", isOn: .constant(false))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 20)
            
            
            
            Spacer()
            
            Button(action: {
                hasRegistered = false
            }) {
                Text("Log Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .onAppear {
            APIRequest.shared.getProfile { result in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        firstname = profile.firstname
                        lastname = profile.lastname
                        email = profile.email
                    }
                case .failure(_):
                    print("error")
                }
            }
        }
    }
}

struct ProfileInfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack() {
            Text("\(title):")
                .font(.headline)
                
            Text(value)
                .font(.body)
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
