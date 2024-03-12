//
//  NewPlannedView.swift
//  iBudget
//
//  Created by Antoine Himpens on 18/02/2024.
//

import SwiftUI
import SwiftData

struct NewPlannedView: View {
    @Binding var showingSheet: Bool
    @State private var showingConfirmationAlert = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\Currency.currency_name)]) var currencies: [Currency]
    @Query var accounts: [Account]  // Récupérer la liste des comptes
    @Query var categories: [Category]  // Récupérer la liste des comptes
            
    @State private var planned_details = String()
    @State private var planned_next_date = Date()
    @State private var planned_end_date = Date()
    @State private var planned_currency: Currency = Currency()
    @State private var planned_category: Category = Category()
    @State private var planned_account: Account = Account()
    @State private var planned_recurrence: Recurrence = .never
            
    @State private var selectedCurrency: Currency = Currency()
    @State private var selectedAccount: Account = Account()
    @State private var selectedCategory: Category = Category()
    
    @State private var amountValue: Double = 0
    @State private var amountText: String = ""
            

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recurrence")) {
                    Picker("TimeScale", selection: $planned_recurrence) {
                        ForEach(Recurrence.allCases) { scale in
                            Text(String(describing: scale))
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if planned_recurrence == .never {
                        DatePicker("Date", selection: $planned_next_date, displayedComponents: .date)
                    } else {
                        DatePicker("Next Occurrence", selection: $planned_next_date, displayedComponents: .date)
                        DatePicker("End Date", selection: $planned_end_date, displayedComponents: .date)
                    }
                }
                
                Section(header: Text("Planned Details")) {
                    TextField("Details", text: $planned_details)
                    
                        TextField("Amount", text: $amountText)
                            .keyboardType(.decimalPad)
                            .onChange(of: amountText) { newValue in
                                if let amount = Double(amountText) {
                                    amountValue = amount
                                }
                            }
                        
                        Picker("Currency", selection: $selectedCurrency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency.currency_name).tag(currency as Currency?)
                            }
                        }
                        .onChange(of: selectedCurrency) { newValue, _ in
                           planned_currency=newValue
                        }
                        
                        Section(header: Text("Account")) {
                             Picker("Account", selection: $selectedAccount) {
                                 ForEach(accounts, id: \.self) { account in
                                     Text(account.account_name).tag(account as Account?)
                                 }
                             }
                         }
                         .onChange(of: selectedAccount) { newAccount, _ in
                             print(newAccount)
                             planned_account = newAccount
                             print(selectedAccount)
                             print(planned_account)

                         }
            
                         Section(header: Text("Category")) {
                             Picker("Category", selection: $selectedCategory) {
                                 ForEach(categories, id: \.self) { category in
                                     Text(category.category_name).tag(category as Category?)
                                 }
                             }
                         }
                         .onChange(of: selectedCategory) { newCategory, _ in
                             planned_category = newCategory
                         }
                    }
                }
            .navigationTitle("New Planned")
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
            addPlanned()
            dismiss()
        }) {
            Text("Save").bold()
        })
        }
    }

    func addPlanned() {
        var planned_transactions: [Transaction] // Tableau des transactions correspondantes
        print(selectedAccount.account_name)
        print(selectedCategory.category_name)
        print(selectedCurrency.currency_name)
        let planned = Planned(planned_next_date: planned_next_date, planned_end_date: planned_end_date, planned_recurrence: planned_recurrence, planned_amount: amountValue, planned_description: planned_details, planned_currency: selectedCurrency, planned_account: selectedAccount, planned_category: selectedCategory)
        
        modelContext.insert(planned)
        
        planned.planned_account = selectedAccount
        planned.planned_category = selectedCategory
        planned.planned_category = selectedCategory
        
        
        planned_transactions=planned.generateTransactions()

   
        // Iterating over the transactions and inserting each one into the managed object context
         for transaction in planned_transactions {
             modelContext.insert(transaction)
         }
        print(planned.description())
        planned.planned_transactions=planned_transactions

    }
    
}
