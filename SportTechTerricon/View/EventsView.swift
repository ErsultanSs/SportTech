//
//  EventsView.swift
//  SportTechTerricon
//
//  Created by Ерсултан Сабырханов on 24.06.2023.
//

import SwiftUI

import SwiftUI

struct EventsView: View {
    @State private var selectedRole: Role = .organizator
    @State private var events: [EventByCategoryModel] = []
    @State private var showEventInfo = false
    @State private var eventId: EventByIdModel = EventByIdModel(id: 0, name: "", code: "", time_and_date: "", place: "", expenditure: [], total_expenditure: 0, event_status: "", bank_account: Bank_account(id: "", value: 0), participants: [], payment_value: 0)
    @State private var token = ""
    @State private var copiedToken = false
    @State private var showToken = false
    @State private var showJoinEvent = false
    @State private var participantToken = ""

    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedRole = .organizator
                    events = []
                    fetchEvents(for: "organizator")
                }) {
                    Text("As Organizer")
                        .foregroundColor(selectedRole == .organizator ? .blue : .black)
                        .padding()
                        .background(selectedRole == .organizator ? Color.blue.opacity(0.5) : Color.clear)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    selectedRole = .participant
                    events = []
                    fetchEvents(for: "participant")
                }) {
                    Text("As Participant")
                        .foregroundColor(selectedRole == .participant ? .blue : .black)
                        .padding()
                        .background(selectedRole == .participant ? Color.blue.opacity(0.5) : Color.clear)
                        .cornerRadius(10)
                }
            }
            .padding(.vertical, 10)
            
            HStack {
                if selectedRole == .participant {
                    Button {
                        showJoinEvent.toggle()
                    } label: {
                        Text("Join a match")
                    }
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(events, id: \.self) { event in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(event.name): \(event.id)")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        
                        if let date = parseDate(event.time_and_date) {
                            Text("Date: \(formatDate(date))")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                        }
                        
                        Text("Place: \(event.place)")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                        
                        ProgressView(value: calculateProgress(event.expenditure))
                            .accentColor(.blue)
                            .padding(.horizontal, 20)
                        
                        Text("Gathered: 1000тг")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Button(action: {
                                showEventInfo = true
                                APIRequest.shared.getEventById(id: event.id) { result in
                                    switch result {
                                    case .success(let event):
                                        DispatchQueue.main.async {
                                            self.eventId = event
                                            
                                        }
                                    case .failure(_):
                                        print("Error getting event by id")
                                    }
                                }
                            }) {
                                Text("More Info")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                APIRequest.shared.generateTokenById(id: event.id) { result in
                                    switch result {
                                    case .success(let token):
                                        DispatchQueue.main.async {
                                            let generatedToken = token.invite_token
                                            self.token = generatedToken
                                            withAnimation {
                                                showToken = true
                                            }
                                        }
                                    case .failure(_):
                                        print("error getting token")
                                    }
                                }
                            }) {
                                Text("Generate Token")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        }
        .blur(radius: showToken ? 10 : 0)
        .overlay(content: {
            generateTokenView(token: token)
                .offset(y: showToken ? 0 : UIScreen.main.bounds.height)
        })
        .overlay(content: {
            joinEventView()
                .offset(y: showJoinEvent ? 0 : UIScreen.main.bounds.height)
        })
        .sheet(isPresented: $showEventInfo) {
            EventInfoView(eventId: eventId.id,eventName: eventId.name, date: eventId.time_and_date, place: eventId.place, totalExpenditure: eventId.total_expenditure, expenditure: eventId.expenditure, participants: eventId.participants, payment_value: eventId.payment_value, selectedRole: selectedRole, eventStatus: eventId.event_status )
            
        }
        .onAppear {
            fetchEvents(for: "organizator")
        }
    }
    
    func joinEventView() -> some View {
         VStack {
             Text("Enter your token to join the event")
                 .font(.headline)
                 .foregroundColor(.primary)
             
             TextField("Token", text: $participantToken)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()
                 .autocapitalization(.none)
             
             Button(action: {
                 APIRequest.shared.validateToken(token: participantToken) { result in
                     switch result {
                     case .success(let message):
                         print(message)
                         showJoinEvent = false
                         
                         APIRequest.shared.refreshToken()
                         fetchEvents(for: "participant")
                     case .failure(_):
                         print("error")
                     }
                 }
             }) {
                 Text("Join Event")
                     .font(.headline)
                     .foregroundColor(.white)
                     .padding(.vertical, 8)
                     .padding(.horizontal, 16)
                     .background(Color.blue)
                     .cornerRadius(10)
                     .disabled(participantToken.isEmpty)
             }
         }
         .padding()
         .background(VisualEffectView(style: .systemThickMaterial))
         .cornerRadius(15)
         .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
     }
    
    func generateTokenView(token: String) -> some View {
        
        VStack {
            Text("Copy the token and send it to participants")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Spacer()
                Text(token)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(VisualEffectView(style: .systemUltraThinMaterial))
            .cornerRadius(15)
            
            HStack {
                Button(action: {
                    UIPasteboard.general.string = token
                    copiedToken = true
                }) {
                    Label("Copy Token", systemImage: "doc.on.doc")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if copiedToken {
                    Text("Copied")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                 
                Spacer()
                
                Button(action: {
                    showToken = false
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
        }
        .padding()
        .background(VisualEffectView(style: .systemThickMaterial))
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }


    
    func calculateProgress(_ expenditures: [ExpenditureEventByCategoryModel]) -> Double {
        let totalCost = expenditures.reduce(0) { $0 + $1.cost }
        let gatheredAmount: Double = 1000.0 // Replace with the actual gathered amount
        let progress = gatheredAmount / Double(totalCost)
        return min(max(progress, 0), 1)
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
    
    private func fetchEvents(for role: String) {
        APIRequest.shared.getEventByCategory(role: role) { result in
            switch result {
            case .success(let event):
                DispatchQueue.main.async {
                    events = event
                }
            case .failure(_):
                print("Error fetching events")
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}

