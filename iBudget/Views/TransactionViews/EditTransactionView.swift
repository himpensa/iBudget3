//
//  EditTransactionView.swift
//  iBudget
//
//  Created by Antoine Himpens on 02/12/2023.
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var transaction: Transaction
    @Query(sort: [SortDescriptor(\Currency.currency_name)]) var currencies: [Currency]
    @Query var accounts: [Account]  // Récupérer la liste des comptes
    @Query var categories: [Category]  // Récupérer la liste des comptes
    @Query var payees: [Payee]  // Récupérer la liste des comptes
    @State private var selectedCurrency: Currency?
    @State private var selectedAccount: Account?
    @State private var selectedCategory: Category?
    @State private var selectedPayee: Payee?
    @State private var amountValue: Double = 0 // Ajout d'une variable pour gérer la saisie de montant

    @State private var amountText: String = ""

    init(transaction: Transaction) {
        self._transaction = Bindable(transaction)
        self._selectedCurrency = State(initialValue: transaction.transaction_currency)
        self._selectedAccount = State(initialValue: transaction.transaction_account)  // Initialiser avec le compte actuel
        self._selectedCategory = State(initialValue: transaction.transaction_category)
        self._selectedPayee = State(initialValue: transaction.transaction_payee)
        self._amountText = State(initialValue: String(format: "%.2f", transaction.transaction_amount))
        
    }
    
    var body: some View {
        Form {
            Section(header: Text("Transaction Details")) {
                Picker("Payee", selection: $selectedPayee) {
                    ForEach(payees, id: \.self) { payee in
                        Text(payee.payee_name).tag(payee as Payee?)
                    }
                }
                .onChange(of: selectedPayee) { newValue, _ in
                    transaction.transaction_payee = selectedPayee
                }
                TextField("Details", text: $transaction.transaction_details)
                DatePicker("Date", selection: $transaction.transaction_date, displayedComponents: .date)
            }
            
            Section(header: Text("Amount and Currency")) {
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .onChange(of: amountText) { newValue, _ in
                        print("New Value:", newValue)
                        if let amount = Double(amountText) {
                            print("Amount:", amount)
                            transaction.transaction_amount = amount
                        } else {
                            print("Unable to convert to Double")
                        }
                    }


                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency.currency_name).tag(currency as Currency?)
                    }
                }
                .onChange(of: selectedCurrency) { newValue, _ in
                    transaction.transaction_currency = selectedCurrency
                }
            }

            Section(header: Text("Account")) {
                Picker("Account", selection: $selectedAccount) {
                    ForEach(accounts, id: \.self) { account in
                        Text(account.account_name).tag(account as Account?)
                    }
                }
            }
            .onChange(of: selectedAccount) { newAccount, _ in
                transaction.transaction_account = selectedAccount
            }
            
            Section(header: Text("Category")) {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.category_name).tag(category as Category?)
                    }
                }
            }
            .onChange(of: selectedCategory) { newCategory, _ in
                print(selectedCategory)
                transaction.transaction_category = selectedCategory
            }
        }
        .navigationTitle("Edit Transaction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

