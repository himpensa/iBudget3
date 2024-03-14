//
//  MenuCleanup.swift
//  iBudget
//
//  Created by Antoine Himpens on 13/03/2024.
//

import SwiftUI

struct MenuCleanup: View {
    let gridItems = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    @State private var showingSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 20) {
                    NavigationLink(destination: ListTransactionNoCategories()) {
                         VStack {
                            Image(systemName: "bookmark.circle")
                                .font(.largeTitle)
                            Text("Transactions without categories")
                                .font(.headline)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                    
         
                    NavigationLink(destination: ListTransactionNoPayee()) {
                        VStack {
                            Image(systemName: "calendar")
                                .font(.largeTitle)
                            Text("Transactions without payee")
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




#Preview {
    MenuCleanup()
}
