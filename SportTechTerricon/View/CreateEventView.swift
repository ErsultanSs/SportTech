//
//  CreateEventView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 23.06.2023.
//

import SwiftUI

struct CreateEventView: View {
    @State private var showAlert = false
    @State private var eventName = ""
    @State private var eventDate = Date()
    @State private var eventPlace = ""
    @State private var expenditureName = ""
    @State private var expenditureCost = ""
    @State private var expenditures: [ExpenditureModel] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Event")
                        .font(.headline)
                        .padding(.horizontal)
                    TextField("Event Name", text: $eventName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    DatePicker("Event Date", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.horizontal)
                    
                    TextField("Event Place", text: $eventPlace)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                .padding()
                
                VStack(spacing: 16) {
                    if !expenditures.isEmpty {
                        Text("Expenditures")
                            .font(.headline)
                    
                        ForEach(expenditures, id: \.self) { expenditure in
                            HStack {
                                Text(expenditure.name)
                                Spacer()
                                Text("\(expenditure.cost)")
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Expenditures (Optional)")
                            .font(.headline)
                            .padding(.horizontal,20)

                        TextField("Enter expenditure name", text: $expenditureName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        
                        TextField("Enter expenditure cost", text: $expenditureCost)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    .padding()
                }
                
                HStack {
                    Button(action: addExpenditure) {
                        Text("Add Expenditure")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: createEvent) {
                        Text("Create Event")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Event Created"),
                    message: Text("Your event has been successfully created."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func addExpenditure() {
        guard let cost = Int(expenditureCost) else { return }
        let expenditure = ExpenditureModel(name: expenditureName, cost: cost)
        expenditures.append(expenditure)
        expenditureName = ""
        expenditureCost = ""
        UIApplication.shared.windows.first?.endEditing(true)

    }
    
    private func deleteExpenditure(at indexSet: IndexSet) {
        expenditures.remove(atOffsets: indexSet)
    }
    
    private func createEvent() {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let event = EventModel(name: eventName, time_and_date: formatter.string(from: eventDate), place: eventPlace, expenditure: expenditures)
        
        
        APIRequest.shared.createEvent(event: event) { result in
            switch result {
            case .success(_):
                expenditures = [] 
                showAlert = true
                eventName = ""
                eventPlace = ""
                expenditureCost = ""
                expenditureName = ""
                
                APIRequest.shared.refreshToken()
            case.failure(_):
                print("error")
            }
        }
        

    }
}



struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}

