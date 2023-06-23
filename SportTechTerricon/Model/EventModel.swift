//
//  EventModel.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import Foundation

struct EventModel {
    var name: String
    var time_and_date: String
    var expenditure: [ExpenditureModel]
}

struct ExpenditureModel {
    var name: String
    var cost: Int
}
