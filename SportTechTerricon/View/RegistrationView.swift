//
//  RegistrationView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 21.06.2023.
//

import SwiftUI

struct RegistrationView: View {
    // MARK: - PROPERTY
    @State private var isLoading = false
    
    @EnvironmentObject private var registrationState: RegistrationState
    @State private var firstName: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showErrorAlert = false
    
    // MARK: - BODY
    var body: some View {
        if !isLoading {
            VStack {
                TextField("Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Second Name", text: $lastname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Register") {
                    if isValidRegistration() {
                        APIRequest.shared.registerUser(user: RegisterUser(firstname: firstName, lastname: lastname, email: email, password: password, confirm: confirmPassword)) { result in
                            switch result {
                            case .success(_):
                                isLoading = false
                                DispatchQueue.main.async {
                                    registrationState.isRegistered = true
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        showErrorAlert = true
                    }
                }
                .padding()
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please make sure all fields are filled correctly."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
            }
            .padding()
        } else {
            ProgressView()
        }
    }
    
    private func isValidRegistration() -> Bool {
        // Perform validation checks here
        if firstName.isEmpty || lastname.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return false
        }
        
        if !email.isValidEmail() {
            return false
        }
        
        if password != confirmPassword {
            return false
        }
        
        return true
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

extension String {
    func isValidEmail() -> Bool {
        // Basic email validation using regular expression
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}


