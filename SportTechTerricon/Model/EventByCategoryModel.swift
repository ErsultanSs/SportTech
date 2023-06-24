//
//  EventByCategoryModel.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 24.06.2023.
//

import Foundation

struct EventByCategoryModel: Decodable, Hashable {
    var id: Int
    var name: String
    var code: String
    var time_and_date: String
    var place: String
    var expenditure: [ExpenditureEventByCategoryModel]
    var total_expenditure: Int
    var bank_account: [BankAccount]
    
}

struct ExpenditureEventByCategoryModel: Decodable, Hashable {
    var cost: Double
    var name: String
}

struct BankAccount: Decodable,Hashable {
    var id: String
    var value: Double
}
