//
//  EventInfoView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 24.06.2023.
//

import SwiftUI

import SwiftUI

struct EventInfoView: View {
    var eventName: String
    var date: String
    var place: String
    var totalExpenditure: Double
    var expenditure: [ExpenditureEventByCategoryModel]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Event Information")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Event Name:")
                    .font(.headline)
                Text(eventName)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Date:")
                    .font(.headline)
                if let parsedDate = parseDate(date) {
                    Text(formatDate(parsedDate))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                } else {
                    Text("Invalid date format")
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Place:")
                    .font(.headline)
                Text(place)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Expenditure:")
                    .font(.headline)
                Text("\(totalExpenditure)")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }
            
            Divider()
            
            Text("Expenditure:")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(expenditure, id: \.self) { expense in
                VStack(alignment: .leading, spacing: 4) {
                    Text("Name: \(expense.name)")
                        .font(.subheadline)
                    Text("Cost: \(expense.cost)")
                        .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
            
            Spacer()
            
            Button(action: {
                // Handle close button action
            }) {
                Text("Close")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: dateString)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}





