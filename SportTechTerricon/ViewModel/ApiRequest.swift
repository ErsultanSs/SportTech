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
    let eventUrl = URL(string: "\(Constants.baseUrl)event")
    let refreshUrl = URL(string: "\(Constants.baseUrl)authentication/refresh")
    
    func validateToken(token: String, completion: @escaping ((Result<ValidateTokenModel, Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseUrl)event/validate-invite-token/\(token)")
        
        do {
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(ValidateTokenModel.self, from: data)
                        completion(.success(response))
                        print("success")
                    } catch {
                        completion(.failure(error))
                        print(String(describing: error))
                    }
                }
            }
            
            task.resume()
            
        }
    }

    
    func generateTokenById(id: Int, completion: @escaping ((Result<InviteTokenModel, Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseUrl)event/generate-invite-token/\(id)")
        
        do {
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(InviteTokenModel.self, from: data)
                        completion(.success(response))
                        print("success")
                    } catch {
                        completion(.failure(error))
                        print(String(describing: error))
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func getEventById(id: Int, completion: @escaping ((Result<EventByIdModel, Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseUrl)event/\(id)")
        
        do {
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(EventByIdModel.self, from: data)
                        completion(.success(response))
                        print("success")
                    } catch {
                        completion(.failure(error))
                        print(String(describing: error))
                    }
                }
            }
            
            task.resume()
            
        }
    }
    func refreshToken() {
        guard let refreshUrl = refreshUrl else { return }
        do {
            var urlRequest = URLRequest(url: refreshUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
                
                
                if let data = data {
                    do {
                        if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                           print("old token: \(token)")
                        }
                        let tokenModel = try JSONDecoder().decode(TokenModel.self, from: data)
                        UserDefaults.standard.set(tokenModel.access_token, forKey: "AuthToken")
                        print("Token is refreshed: \(tokenModel.access_token)")
                    } catch {
                        print(String(describing: error))
                        print("Token is not refreshed")
                    }
                }
            }
            
            task.resume()
            
        }
    }

    
    func getEventByCategory(role: String, completion: @escaping ((Result<[EventByCategoryModel], Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseUrl)event/filter_by_role/\(role)")
        
        do {
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode([EventByCategoryModel].self, from: data)
                        completion(.success(response))
                        print("success")
                    } catch {
                        completion(.failure(error))
                        print(String(describing: error))
                    }
                }
            }
            
            task.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
    
    func exitEvent(eventId: Int, completion: @escaping ((Result<EventResponseModel, Error>) -> Void)) {
        
        let url = URL(string: "\(Constants.baseUrl)event/exit/\(eventId)")

        
        do {
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            
          
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(EventResponseModel.self, from: data)
                        completion(.success(response))
                        print("\(response.message)")
                    } catch {
                        completion(.failure(error))
                        print("error exiting event: \(error.localizedDescription)")
                    }
                }
            }
            
            task.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
    
    func pay(eventId: Int,value: Double, completion: @escaping ((Result<EventResponseModel, Error>) -> Void)) {
        
        let url = URL(string: "\(Constants.baseUrl)event/change-event-status/\(eventId)")

        
        do {
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            let requestBody: [String: Any] = [
                "event_id" : eventId,
                "value": value
                
            ]
            
            do {
                    let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                    urlRequest.httpBody = jsonData
                } catch {
                    completion(.failure(error))
                    return
                }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(EventResponseModel.self, from: data)
                        completion(.success(response))
                        print("\(response.message)")
                    } catch {
                        completion(.failure(error))
                        print("error changin event status: \(error.localizedDescription)")
                    }
                }
            }
            
            task.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
    
    func changeEventStatus(eventId: Int,status: String, completion: @escaping ((Result<EventResponseModel, Error>) -> Void)) {
        
        let url = URL(string: "\(Constants.baseUrl)event/change-event-status/\(eventId)")

        
        do {
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            let requestBody: [String: Any] = [
                    "event_status": "\(status)"
            
            ]
            
            do {
                    let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                    urlRequest.httpBody = jsonData
                } catch {
                    completion(.failure(error))
                    return
                }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(EventResponseModel.self, from: data)
                        completion(.success(response))
                        print("\(response.message)")
                    } catch {
                        completion(.failure(error))
                        print("error changin event status: \(error.localizedDescription)")
                    }
                }
            }
            
            task.resume()
            
        } catch {
            completion(.failure(error))
        }
    }

    
    func createEvent(event: EventModel, completion: @escaping ((Result<EventResponseModel, Error>) -> Void)) {
        guard let eventUrl = eventUrl else { return }
        
        do {
            var urlRequest = URLRequest(url: eventUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(event)
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(EventResponseModel.self, from: data)
                        completion(.success(response))
                        print("\(response.message)")
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
