//
//  EventInfoView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 24.06.2023.
//

import SwiftUI

import SwiftUI

struct EventInfoView: View {
    var eventId: Int
    var eventName: String
    var date: String
    var place: String
    var totalExpenditure: Double
    var expenditure: [ExpenditureEventByCategoryModel]
    var participants: [Participants]
    var payment_value: Double
    @State var showAlert = false
    @State var selectedRole: Role
    @State var eventStatus: String
    @State var hideButtons = false
    @State var showPaySheet = false
    @Environment(\.self) var env

    
    var body: some View {
        VStack(spacing: 16) {
            Text("Event Information")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 8) {
                    Text("Event Name:")
                        .font(.headline)
                    Text(eventName)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                }
                .padding()
                .background(Color.gray.opacity(0.233))
                .cornerRadius(15)
                
                HStack(spacing: 8) {
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
                .padding()
                .background(Color.gray.opacity(0.233))
                .cornerRadius(15)
                
                HStack(spacing: 8) {
                    Text("Place:")
                        .font(.headline)
                    Text(place)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                }
                .padding()
                .background(Color.gray.opacity(0.233))
                .cornerRadius(15)
                
                HStack( spacing: 8) {
                    Text("Total Expenditure:")
                        .font(.headline)
                    Text("\(Int(totalExpenditure))тг")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                }
                .padding()
                .background(Color.gray.opacity(0.233))
                .cornerRadius(15)
            }
            
            Divider()
            
            Text("Expenditure Information")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                ForEach(expenditure, id: \.self) { expense in
                    VStack(alignment: .leading,spacing: 10) {
                        Text("Name: \(expense.name)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Cost: \(Int(expense.cost))")
                            .font(.subheadline)
                            .fontWeight(.semibold)


                    }
                    .padding()
                    .background(Color.gray.opacity(0.233))
                    .cornerRadius(15)
                }
            }
            
            Text("Participants")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                ForEach(participants, id: \.self) { participant in
                    VStack(alignment: .leading,spacing: 10) {
                        HStack {
                            Text("\(participant.participant_firstname)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("\(participant.participant_lastname):")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            if eventStatus == "payment" {
                                if participant.participant_is_paid {
                                    Text("Paid")
                                        .foregroundColor(.green)
                                } else {
                                    HStack {
                                        Text("Not paid")
                                            .foregroundColor(.red)
                                        
                                        Text("Must pay: \(Int(participant.participant_payment_value))тг")
                                    }
                                    
                                }
                            }
                            
                        }

                    }
                    .padding()
                    .background(Color.gray.opacity(0.233))
                    .cornerRadius(15)
                }
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    env.dismiss()
                }) {
                    Text("Close")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if selectedRole == .organizator {
                    if eventStatus == "created" {
                        Button {
                            APIRequest.shared.changeEventStatus(eventId: eventId, status: "pre_payment") { result in
                                switch result {
                                case .success(_):
                                    print("changed event status to pre-payment")
                                case .failure(_):
                                    print("could not change")
                                }
                            }
                            
//                            self.eventStatus = "pre-payment"
                        } label: {
                            Text("Pre-Payment")
                                .foregroundColor(.green)
                                .padding()
                                .background(Color.gray.opacity(0.233))
                                .cornerRadius(15)
                        }
                    } else if eventStatus == "pre_payment" {
                        Button {
                            APIRequest.shared.changeEventStatus(eventId: eventId, status: "payment") { result in
                                switch result {
                                case .success(_):
                                    print("changed event status to payment")
                                case .failure(_):
                                    print("could not change")
                                }
                            }
                            
//                            self.eventStatus = "payment"
                        } label: {
                            Text("Payment")
                                .foregroundColor(.green)
                                .padding()
                                .background(Color.gray.opacity(0.233))
                                .cornerRadius(15)
                        }

                    }
                } else if selectedRole == .participant {
                    HStack {
                        if eventStatus == "pre_payment" {

                            HStack {
                                Button {
                                    showAlert = true
                                    hideButtons = true
                                } label: {
                                    Text("Accept")
                                        .foregroundColor(.green)
                                        .padding()
                                        .background(Color.gray.opacity(0.233))
                                        .cornerRadius(15)
                                }
                                
                                
                                Button {
                                    APIRequest.shared.exitEvent(eventId: eventId) { result in
                                        switch result {
                                        case .success(_):
                                            print("exited match")
                                        case .failure(_):
                                            print("error exiting")
                                        }
                                    }
                                    
                                    selectedRole = .participant
                                    
                                    
                                    env.dismiss()
                                    
                                } label: {
                                    Text("Decline")
                                        .foregroundColor(.red)
                                        .padding()
                                        .background(Color.gray.opacity(0.233))
                                        .cornerRadius(15)
                                }

                            }
                            .opacity(hideButtons ? 0 : 1)
                        } else if eventStatus == "payment" {
                            HStack {
                                Button {
                                    showPaySheet = true
                                    
                                } label: {
                                    Text("Pay")
                                        .foregroundColor(.green)
                                        .padding()
                                        .background(Color.gray.opacity(0.233))
                                        .cornerRadius(15)
                                }
                                
                                

                            }

                        }
                            
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("You have accepted the match"),
                message: Text("Now wait for the payment."),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $showPaySheet) {
            PayView(value: payment_value, eventId: eventId)
        }

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





