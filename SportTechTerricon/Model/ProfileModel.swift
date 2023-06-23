//
//  ProfileModel.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import Foundation

struct ProfileModel: Decodable {
    var user_id: Int
    var email: String
    var firstname: String
    var lastname: String
    var iat: Int
    var exp: Int
}
