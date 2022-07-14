//
//  ContentView.swift
//  swiftlist
//
//  Created by Dagg on 7/9/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                HomeView(requestedSubreddit: "news")
            }.tabItem {
                Image(systemName: "newspaper.fill")
                Text("News")
            }.tag(1)
            NavigationView {
                HomeView()
            }.tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }.tag(0)
            NavigationView {
                HomeView(requestedSubreddit: "all")
            }.tabItem {
                Image(systemName: "star.fill")
                Text("All")
            }.tag(2)
            NavigationView{
                SearchView()
            }.tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }.tag(3)
            NavigationView{
                AccountView()
            }.tabItem {
                Image(systemName: "person.fill")
                Text("Account")
            }.tag(4)
        }
    }
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
