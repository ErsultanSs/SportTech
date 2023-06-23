//
//  RegistrationModel.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import Foundation

struct RegisterUser: Decodable, Encodable {
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var confirm: String

}
