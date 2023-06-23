//
//  ApiRequest.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import Foundation

struct APIRequest {
    static let shared = APIRequest()
    let registerUrl = URL(string: "\(Constants.baseUrl)authentication/register")
    let getProfileUrl = URL(string: "\(Constants.baseUrl)user/me")
    let loginUrl = URL(string: "\(Constants.baseUrl)authentication/login")

    
    func loginUser(user: LoginModel, completion: @escaping ((Result<TokenModel, Error>) -> Void)) {
        guard let loginUrl = loginUrl else { return }
        
        do {
            var urlRequest = URLRequest(url: loginUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(user)
            
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
                
                if let data = data {
                    do {
                        let tokenModel = try JSONDecoder().decode(TokenModel.self, from: data)
                        completion(.success(tokenModel))
                        UserDefaults.standard.set(tokenModel.access_token, forKey: "AuthToken")
                        print("Success: \(tokenModel.access_token)")
                    } catch {
                        completion(.failure(error))
                        print("error: \(error.localizedDescription)")
                    }
                }

            }
            
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func registerUser(user: RegisterUser, completion: @escaping ((Result<TokenModel, Error>) -> Void)) {
        guard let registerUrl = registerUrl else { return }
        
        do {
            var urlRequest = URLRequest(url: registerUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(user)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let tokenModel = try JSONDecoder().decode(TokenModel.self, from: data)
                        completion(.success(tokenModel))
                        UserDefaults.standard.set(tokenModel.access_token, forKey: "AuthToken")
                        print("Success: \(tokenModel.access_token)")
                    } catch {
                        completion(.failure(error))
                        print("error: \(error.localizedDescription)")
                    }
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func getProfile(completion: @escaping ((Result<ProfileModel, Error>) -> Void)) {
        guard let getProfileUrl = getProfileUrl else { return }
        
        var urlRequest = URLRequest(url: getProfileUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "AuthToken") {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let profileModel = try JSONDecoder().decode(ProfileModel.self, from: data)
                    completion(.success(profileModel))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
