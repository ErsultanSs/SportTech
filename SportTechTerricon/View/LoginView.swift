//
//  LoginView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.bottom, 30)
            
            Text("Login")
                .font(.title)
                .bold()
            
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .modifier(ValidationModifier(isValid: isEmailValid))
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .modifier(ValidationModifier(isValid: isPasswordValid))
                
                Button(action: {
                    validateFields()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
    
    private func validateFields() {
        isEmailValid = isValidEmail(email)
        isPasswordValid = isValidPassword(password)
        
        if isEmailValid && isPasswordValid {
            APIRequest.shared.loginUser(user: LoginModel(username: email, password: password)) { result in
                switch result {
                case .success(_):
                    print("success")
                case .failure(_):
                    print("error")
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}

struct ValidationModifier: ViewModifier {
    let isValid: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(isValid ? Color.green : Color.red, lineWidth: 1)
            )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

