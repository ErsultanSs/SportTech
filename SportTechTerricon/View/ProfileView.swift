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
    var body: some View {
        VStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.bottom, 20)
            
            Text("Profile")
                .font(.title)
                .bold()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("First Name:")
                    .font(.headline)
                Text(firstname)
                
                Text("Last Name:")
                    .font(.headline)
                Text(lastname)
                
                Text("Email:")
                    .font(.headline)
                Text(email)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
            
            Spacer()
        }
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
