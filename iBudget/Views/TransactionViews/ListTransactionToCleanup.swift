//
//  ListTransactionToCleanup.swift
//  iBudget
//
//  Created by Antoine Himpens on 12/03/2024.
//

import SwiftUI
import SwiftData

struct ListTransactionToCleanup: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Transaction>{ transaction in
        transaction.transaction_category == nil
        }) var transactions: [Transaction]
    @Query var accounts: [Account]
    @State private var lastDate = DateFormatter().date(from: "2020/01/01") ?? Date()
    @State private var selectedAccount: Account? = nil
    

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(transactions, id: \.self) { transaction in
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
                .navigationBarTitle("", displayMode: .inline)
            }
        }
    }
    


    private func dateFormatted(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Category.self, Transaction.self, configurations: config)

    let sampleCategory = Category(category_name: "Restaurant", category_icon: "questionmark.circle", parentID: nil)
    let sampleAccount = Account(account_name: "Courant", account_description: "test", account_currency: nil, account_type: "Cash", starting_balance: 0, is_opened: true, account_is_default: false, transactions: [])
    let sampleTransaction =  Transaction(transaction_details: "dfgfg", transaction_date: .now, transaction_amount: 0, transaction_currency: nil, transaction_account: sampleAccount, transaction_category: sampleCategory, transaction_completed: true)
       
    container.mainContext.insert(sampleTransaction)

    return ListTransactionToCleanup()
        .modelContainer(container)
}
