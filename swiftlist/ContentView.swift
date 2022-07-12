//
//  ContentView.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }.tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            NavigationView{
                SearchView()
            }.tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            NavigationView{
                AccountView()
            }.tabItem {
                Image(systemName: "person.fill")
                Text("Account")
            }
        }
    }
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
