//
//  EventByIdModel.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 24.06.2023.
//

import Foundation

struct EventByIdModel: Decodable, Hashable {
    let id: Int
    let name: String
    let code: String
    let time_and_date: String
    let place: String
    let expenditure: [ExpenditureEventByCategoryModel]
    let total_expenditure: Double
    let bank_account: Bank_account
    let participants: [Participants]
}


struct Bank_account: Decodable, Hashable {
    let id: String
    let value: Double
}

struct Participants: Decodable, Hashable {
    let participant_id: Int
    let participant_role: String
    let participant_email: String
    let participant_firstname: String
    let participant_lastname: String
}
