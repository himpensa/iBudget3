//
//  EditTransactionView.swift
//  iBudget
//
//  Created by Antoine Himpens on 02/12/2023.
//

import SwiftUI
import SwiftData

struct NewTransactionView: View {
    @State private var showingConfirmationAlert = false
    @Environment(\.dismiss) var dismiss

    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Currency.currency_name)]) var currencies: [Currency]
    @Query var accounts: [Account]  // Récupérer la liste des comptes
    @Query var categories: [Category]  // Récupérer la liste des comptes
    @State private var selectedCurrency: Currency?
    @State private var selectedAccount: Account?
    @State private var selectedCategory: Category?
    
    @State private var amountValue: Double = 0 // Ajout d'une variable pour gérer la saisie de montant
    @State private var amountText: String = ""
    
    @State private var transaction_details = String()
    @State private var transaction_date: Date = .now
    @State private var transaction_id: UUID = UUID()
    @State private var transaction_amount: Double = 0
    @State private var transaction_currency: Currency?
    @State private var transaction_account: Account?
    @State private var transaction_category: Category?
    
        var body: some View {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Details", text: $transaction_details)
                    DatePicker("Date", selection: $transaction_date, displayedComponents: .date)
                }
                
                Section(header: Text("Amount and Currency")) {
                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                        .onChange(of: amountText) { newValue, _ in
                            print("New Value:", newValue)
                            if let amount = Double(amountText) {
                                transaction_amount = amount
                                print("Amount:", amount)
                            } else {
                                print("Unable to convert to Double")
                            }
                        }


                    currencyPicker
                }

                Section(header: Text("Account")) {
                    Picker("Account", selection: $selectedAccount) {
                        ForEach(accounts, id: \.self) { account in
                            Text(account.account_name).tag(account as Account?)
                        }
                    }
                }
                .onChange(of: selectedAccount) { newAccount, _ in
                    transaction_account = selectedAccount
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
                    transaction_category = selectedCategory
                }
            }
            .navigationTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                showingConfirmationAlert = true
            }) {
                Text("Cancel").foregroundColor(.red)
                    .alert(isPresented: $showingConfirmationAlert) {
                        Alert(title: Text("Are you sure?"), message: Text("Your changes will not be saved."), primaryButton: .default(Text("Yes")) {
                            dismiss()
                        }, secondaryButton: .cancel(Text("No")))
                    }
            }, trailing: Button(action: {
                print("Saved")
                addTransaction()
                dismiss()
            }) {
                Text("Save").bold()
            })
        }
    
    private var currencyPicker: some View {
        Picker(selection: $selectedCurrency, label: Text("Currency")) {
            if currencies.isEmpty {
                // If currencies array is empty, show a default value
                Text("Sélectionnez").tag(nil as Currency?)
            } else {
                ForEach(currencies, id: \.self) { currency in
                    Text(currency.currency_name).tag(currency as Currency?)
                }
            }
        }
        .onAppear {
            if currencies.isEmpty {
                // If currencies array is empty, set the default value to nil
                selectedCurrency = nil
            } else {
                selectedCurrency = currencies.first { $0.currency_is_default }
            }
        }
    }
    
    func addTransaction() {
        let transaction = Transaction(transaction_id: transaction_id, transaction_details: transaction_details, transaction_date: transaction_date, transaction_amount: transaction_amount, transaction_currency: nil, transaction_account: nil, transaction_category: nil, transaction_completed: true)
        modelContext.insert(transaction)
        transaction.transaction_currency=selectedCurrency
        transaction.transaction_account=selectedAccount
        transaction.transaction_category=selectedCategory
    }
    
}

