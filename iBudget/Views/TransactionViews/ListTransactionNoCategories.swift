//
//  ListTransactionToCleanup.swift
//  iBudget
//
//  Created by Antoine Himpens on 12/03/2024.
//
import SwiftUI
import SwiftData
struct ListTransactionNoCategories: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Transaction>{ transaction in
        transaction.transaction_category == nil
        }) var transactions: [Transaction]
    @State private var searchText = ""
    var body: some View {
          NavigationStack {
              List {
                  ForEach(searchResults, id: \.self) { transaction in
                      NavigationLink(destination: EditTransactionView(transaction: transaction)) {
                      VStack {
                          HStack {
                              Image(systemName: transaction.transaction_category?.category_icon ?? "default_icon_name")
                              Text(transaction.transaction_details)
                                  .font(.headline)
                              Spacer()
                              Text(String(format: "%.2f", transaction.transaction_amount))
                                  .font(.headline)
                              }
                          }
                      }
                  }
              }
          }
          .searchable(text: $searchText) {
              ForEach(searchResults, id: \.self) { result in
                  Text("Are you looking for \(result.transaction_details)?").searchCompletion(result.transaction_details)
              }
          }
      }
      var searchResults: [Transaction] {
          if searchText.isEmpty {
              return transactions
          } else {
              return transactions.filter { $0.transaction_details.localizedCaseInsensitiveContains(searchText) }
          }
      }
  }
