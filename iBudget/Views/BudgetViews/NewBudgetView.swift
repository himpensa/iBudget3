//
//  NewBudgetSheetView.swift
//  iBudget
//
//  Created by Antoine Himpens on 04/02/2024.
//

import SwiftUI
import SwiftData

struct NewBudgetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var categories: [Category]
    @Binding var showingSheet: Bool
    @State private var showingConfirmationAlert = false

        
    @State private var budget_title: String = ""
    @State private var budget_start_date: Date=Date()
    @State private var budget_end_date: Date=Date()
    @State private var budget_limit: Double=0
    @State private var budget_category: Category?=nil
    
    
    @State private var selectedDate = Date()
    @State private var selectedNumber: Int = 1
    @State private var selectedInterval: Interval = .month // Default to Month
    @State private var selectedCategory: Category?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Budget Title")) {
                    TextField("Name", text: $budget_title)
                }
                Section(header: Text("Recurrence")) {
                    HStack {
                        Picker("Tous les ", selection: $selectedNumber) {
                                        ForEach(0 ..< 10) { number in
                                            Text("\(number)")
                                        }
                                    }
                        Picker("", selection: $selectedInterval) {
                            ForEach(Interval.allCases, id: \.self) { interval in
                                Text(interval.rawValue)
                            }
                        }
                    }
                }

                Section(header: Text("Start Date")) {
                    VStack {
                        DatePicker("Start Date", selection: $budget_start_date, displayedComponents: [.date])
                        DatePicker("End Date", selection: $budget_end_date, displayedComponents: [.date])
                    }
                }
            
                Section(header: Text("Budget Limit")) {
                    TextField("Limit", value: $budget_limit, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Category")) {
                    categoryPicker
                    
                }
            }
            .navigationBarTitle(Text("New Budget"), displayMode: .inline)
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
                addBudget()
                dismiss()
            }) {
                Text("Save").bold()
            })
        }
    }
        
        
        private var categoryPicker: some View {
            Picker(selection: $budget_category, label: Text("Category")) {
                if categories.isEmpty {
                    // If categories array is empty, show a default value
                    Text("Sélectionnez").tag(nil as Category?)
                } else {
                    ForEach(categories, id: \.self) { category in
                        Text(category.category_name).tag(category as Category?)
                    }
                }
            }
            .onAppear {
                if categories.isEmpty {
                    // If categories array is empty, set the default value to nil
                    budget_category = nil
                } else {
                    budget_category = categories.first
                }
        }
        }
    
    func addBudget() {
        var enveloppes: [Enveloppe]
        
        guard let budget_category = budget_category else {
            print("Selected category is nil")
            return
        }
        print(budget_category.category_name)
        print(budget_category.category_name)

        let budget = Budget(budget_name: budget_title, budget_start_date: budget_start_date, budget_end_date: budget_end_date, budget_limit: 0, budget_number: 1, budget_interval: .month, budget_category: budget_category)
        
        modelContext.insert(budget)
        
        budget.budget_category = budget_category
        
        enveloppes = budget.generateEnveloppes()
        
        // Iterating over the transactions and inserting each one into the managed object context
         for enveloppe in enveloppes {
             modelContext.insert(enveloppe)
             print(enveloppe.description())

         }
    //    budget.=planned_transactions

    }
    
    
}
