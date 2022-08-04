//
//  LoginView.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.openURL) var openURL
    @State private var account: String?
    @State private var loggedIn: Bool = false
    @State private var expiryDate: Date?
    @State private var state: UUID?
    
    var body: some View {
        List {
            switch loggedIn {
            case true:
                Text("Valid until \(expiryDate?.formatted(date: .abbreviated, time: .shortened) ?? Date().addingTimeInterval(86400).formatted(date: .abbreviated, time: .shortened))")
                Button {
                    Task {
                        await getKeychain(action: "delAll")
                        loggedIn.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "door.left.hand.open")
                        Text("Logout")
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.secondary)
                    }
                }
            default:
                Button {
                    state = UUID()
                    let clientId: String = getAppchain().clientId
                    openURL(URL(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=\(clientId)&response_type=code&state=\(state!)&redirect_uri=swiftlist://authorize&duration=temporary&scope=read,identity")!)
                } label: {
                    HStack {
                        Image(systemName: "door.left.hand.open")
                        Text("Login")
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.secondary)
                    }
                }.onOpenURL { URL in
                    let components = URLComponents(url: URL, resolvingAgainstBaseURL: false)
                    
                    guard let authToken = components?.queryItems?[1].value else { return }
                    
                    storeToken(token: authToken)
                    Task {
                        await getKeychain()
                        loggedIn.toggle()
                    }
                }
            }
        }.navigationTitle(account ?? "My Account").listStyle(.plain).task {
            do {
                let expiry = getExpiry()
                if(expiry != nil) {
                    loggedIn = true
                    expiryDate = expiry
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationStack {
                AccountView()
            }.tabItem {
                Image(systemName: "star.fill")
                Text("Tab")
            }
        }
    }
}
