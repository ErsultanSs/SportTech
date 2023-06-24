//
//  EventModel.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import Foundation

struct EventModel: Encodable {
    var name: String
    var time_and_date: String
    var place: String
    var expenditure: [ExpenditureModel]
}

struct ExpenditureModel: Decodable, Encodable, Hashable {
    var name: String
    var cost: Int
}
