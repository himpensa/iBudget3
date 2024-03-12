//
//  ImportJSONView.swift
//  iBudget
//
//  Created by Antoine Himpens on 06/01/2024.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var categories: [Category]
    @Query var accounts: [Account]
    @Query var currencies: [Currency]
    @Query var transactions: [Transaction]
    @Query var tags: [Tag]
    @Query var payees: [Payee]
    @Query var budgets: [Budget]
    @State private var newCurrencies: [Currency] = []
    @State private var newCategories: [Category] = []
    @State private var newAccounts: [Account] = [] // Nouvelle collection pour stocker les nouvelles devises
    @State private var newTransactions: [Transaction] = [] // Nouvelle collection pour stocker les nouvelles devises
    @State private var newTags: [Tag] = [] // Nouvelle collection pour stocker les nouvelles devises
    @State private var newBudgets: [Budget] = [] // Nouvelle collection pour stocker les nouvelles devises
    @State private var newPayees: [Payee] = [] // Nouvelle collection pour stocker les nouvelles devises

    var body: some View {
        VStack {
            Button("Generate Envelopes") {
                var enveloppes: [Enveloppe]
                var budget_title: String = ""
                var budget_start_date: Date=Date()
                var budget_end_date: Date=Date()
                var budget_limit: Double=0
                let budget_category = Category(category_name: "Restaurant", category_icon: "questionmark.circle", parentID: nil)
                
                var calendar = Calendar.current

                budget_end_date = calendar.date(byAdding: .month, value: 3, to: budget_start_date)!

                let budget = Budget(budget_name: budget_title, budget_start_date: budget_start_date, budget_end_date: budget_end_date, budget_limit: 0, budget_number: 1, budget_interval: .day, budget_category: budget_category)
                
          //      modelContext.insert(budget)
                
          //      budget.budget_category = budget_category
                
                enveloppes = budget.generateEnveloppes()
                
                // Iterating over the transactions and inserting each one into the managed object context
                 for enveloppe in enveloppes {
                     //modelContext.insert(enveloppe)
                     print(enveloppe.description())

                 }
            }
            Spacer()
            Button("Effacer les données") {
                do {
                    try modelContext.delete(model: Currency.self)
                    try modelContext.delete(model: Category.self)
                    try modelContext.delete(model: Account.self)
                    try modelContext.delete(model: Transaction.self)
                    try modelContext.delete(model: Tag.self)
                    try modelContext.delete(model: Budget.self)
                    try modelContext.delete(model: Payee.self)
                } catch {
                    print("Failed to clear all Country and City data.")
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            Button("Exporter les données") {
                let dataContainer = DataContainer(categories: categories, accounts: accounts, currencies: currencies, transactions: transactions, budgets: budgets, tags: tags, payees: payees)
                encodeData(data: dataContainer, toFile: "data.json")
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            Button("Importer les données") {
                if let decodedData: DataContainer = decodeData(fromFile: "data.json") {
                    for category in decodedData.categories {
                        if !categoryExistsInCurrentImport(category: category) {
                            if !categoryExistsInCurrentData(category: category) {
                                newCategories.append(category)
                                modelContext.insert(category)
                                print("Category ajoutée: \(category.category_name)")
                            } else {
                                print("Category déjà présente: \(category.category_name)")
                            }
                        } else {
                            print("Category déjà présent: \(category.category_name)")
                        }
                    }
                    for account in decodedData.accounts {
                        if !accountExistsInCurrentImport(account: account) {
                            if !accountExistsInCurrentData(account: account) {
                                newAccounts.append(account)
                                modelContext.insert(account)
                                print("Account ajouté: \(account.account_name)")
                            } else {
                                print("Account déjà présent: \(account.account_name)")
                            }
                        } else {
                            print("Account déjà présent: \(account.account_name)")
                        }
                    }
                    for transaction in decodedData.transactions {
                        if !transactionExistsInCurrentImport(transaction: transaction) {
                            if !transactionExistsInCurrentData(transaction: transaction) {
                                newTransactions.append(transaction)
                                modelContext.insert(transaction)
                                print("Transaction ajouté: \(transaction.transaction_details)")
                            } else {
                                print("Transaction déjà présent: \(transaction.transaction_details)")
                            }
                        } else {
                            print("Transaction déjà présent: \(transaction.transaction_details)")
                        }
                    }
                    for currency in decodedData.currencies {
                        if !currencyExistsInCurrentImport(currency: currency) {
                            if !currencyExistsInCurrentData(currency: currency) {
                                newCurrencies.append(currency)
                                modelContext.insert(currency)
                                print("Currency ajouté: \(currency.currency_alphabetic_code)")
                            } else {
                                print("Currency déjà présent: \(currency.currency_alphabetic_code)")
                            }
                        } else {
                            print("Currency déjà présent: \(currency.currency_alphabetic_code)")
                        }
                    }
                    for budget in decodedData.budgets {
                        if !budgetExistsInCurrentImport(budget: budget) {
                            if !budgetExistsInCurrentData(budget: budget) {
                                newBudgets.append(budget)
                                modelContext.insert(budget)
                                print("Budget ajouté: \(budget.budget_name)")
                            } else {
                                print("Budget déjà présent: \(budget.budget_name)")
                            }
                        } else {
                            print("Budget déjà présent: \(budget.budget_name)")
                        }
                    }
                    for tag in decodedData.tags {
                        if !tagExistsInCurrentImport(tag: tag) {
                            if !tagExistsInCurrentData(tag: tag) {
                                newTags.append(tag)
                                modelContext.insert(tag)
                                print("Tag ajouté: \(tag.tag_name)")
                            } else {
                                print("Tag déjà présent: \(tag.tag_name)")
                            }
                        } else {
                            print("Tag déjà présent: \(tag.tag_name)")
                        }
                    }
                    for payee in decodedData.payees {
                        if !payeeExistsInCurrentImport(payee: payee) {
                            if !payeeExistsInCurrentData(payee: payee) {
                                newPayees.append(payee)
                                modelContext.insert(payee)
                                print("Payee ajouté: \(payee.payee_name)")
                            } else {
                                print("Payee déjà présent: \(payee.payee_name)")
                            }
                        } else {
                            print("Payee déjà présent: \(payee.payee_name)")
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}




extension SettingsView {

    private func categoryExistsInCurrentData(category: Category) -> Bool {
        return categories.contains(where: { $0.category_id == category.category_id })
    }
    private func categoryExistsInCurrentImport(category: Category) -> Bool {
        return newCategories.contains(where: { $0.category_name == category.category_name })
    }
    private func accountExistsInCurrentData(account: Account) -> Bool {
        return accounts.contains(where: { $0.account_id == account.account_id })
    }
    private func accountExistsInCurrentImport(account: Account) -> Bool {
        return newAccounts.contains(where: { $0.account_name == account.account_name })
    }
    private func currencyExistsInCurrentData(currency: Currency) -> Bool {
        return currencies.contains(where: { $0.currency_numeric_code == currency.currency_numeric_code })
    }
    private func currencyExistsInCurrentImport(currency: Currency) -> Bool {
        return newCurrencies.contains(where: { $0.currency_numeric_code == currency.currency_numeric_code })
    }
    private func transactionExistsInCurrentData(transaction: Transaction) -> Bool {
        return transactions.contains(where: { $0.transaction_id == transaction.transaction_id })
    }
    private func transactionExistsInCurrentImport(transaction: Transaction) -> Bool {
        return newTransactions.contains(where: { $0.transaction_details == transaction.transaction_details })
    }
    private func payeeExistsInCurrentData(payee: Payee) -> Bool {
        return payees.contains(where: { $0.payee_id == payee.payee_id })
    }
    private func tagExistsInCurrentData(tag: Tag) -> Bool {
        return tags.contains(where: { $0.tag_id == tag.tag_id })
    }
    private func budgetExistsInCurrentData(budget: Budget) -> Bool {
        return budgets.contains(where: { $0.budget_id == budget.budget_id })
    }
    private func tagExistsInCurrentImport(tag: Tag) -> Bool {
        return newTags.contains(where: { $0.tag_name == tag.tag_name })
    }
    private func budgetExistsInCurrentImport(budget: Budget) -> Bool {
        return newBudgets.contains(where: { $0.budget_name == budget.budget_name })
    }
    private func payeeExistsInCurrentImport(payee: Payee) -> Bool {
        return newPayees.contains(where: { $0.payee_id == payee.payee_id })
    }
}
