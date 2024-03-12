//
//  MenuView.swift
//  iBudget
//
//  Created by Antoine Himpens on 06/01/2024.
//

import SwiftUI

struct MenuView: View {
    let gridItems = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    @State private var showingSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 20) {
                    NavigationLink(destination: ListTagsView()) {
                         VStack {
                            Image(systemName: "bookmark.circle")
                                .font(.largeTitle)
                            Text("Tags")
                                .font(.headline)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                    NavigationLink(destination: ListCurrenciesView()) {
                        VStack {
                            Image(systemName: "dollarsign.circle")
                                .font(.largeTitle)
                            Text("Currencies")
                                .font(.headline)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                NavigationLink(destination: ListAccountsView()) {
                    VStack {
                        Image(systemName: "creditcard")
                            .font(.largeTitle)
                        Text("Accounts")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                        
                NavigationLink(destination: ListPayeesView()) {
                    VStack {
                        Image(systemName: "cart")
                            .font(.largeTitle)
                        Text("Payees")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                            
                NavigationLink(destination: ListCategoriesView()) {
                    VStack {
                        Image(systemName: "car.fill")
                            .font(.largeTitle)
                        Text("Categories")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                    
                    NavigationLink(destination: ImportTransactionsViews()) {
                        VStack {
                            Image(systemName: "doc.circle")
                                .font(.largeTitle)
                            Text("QIF Import")
                                .font(.headline)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gear")
                                .font(.largeTitle)
                            Text("Settings")
                                .font(.headline)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                    NavigationLink(destination: NewTransactionView()) {
                        VStack {
                            Image(systemName: "dollarsign.circle")
                                .font(.largeTitle)
                            Text("Transaction")
                                .font(.headline)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    NavigationLink(destination: NewPlannedView(showingSheet: $showingSheet)) {
                        VStack {
                            Image(systemName: "calendar")
                                .font(.largeTitle)
                            Text("Planned")
                                .font(.headline)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }

                }
                .padding(.horizontal)
            }
        }
    }
}


