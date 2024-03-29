//
//  ListAccountsView.swift
//  iBudget
//
//  Created by Antoine Himpens on 04/12/2023.
//


import SwiftUI
import SwiftData

struct ListAccountsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var accounts: [Account]
    @State private var path = [Account]()
    @State private var showingSheet = false

    var body: some View {
        NavigationStack(path: $path) {
            List {
                
                ForEach(accounts) { account in
                    NavigationLink(value: account) {
                        VStack(alignment: .leading) {
                            Text(account.account_name)
                                .font(.headline)
                        }
                    }
                }
                .onDelete(perform: deleteAccount)

            }
            .navigationTitle("Accounts")
            .navigationDestination(for: Account.self, destination: EditAccountView.init)

            .toolbar {
                Button("Add Accounts", systemImage: "plus") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    NewAccountView(showingSheet: $showingSheet)
                }
            }
        }
    }
    
    func addAccount() {
        let account = Account()
        modelContext.insert(account)
        // Vérifier si l'account n'est pas déjà dans path avant de l'ajouter
            if !path.contains(account) {
                path = [account]
            }
    }
    
    func deleteAccount(_ indexSet: IndexSet) {
        for index in indexSet {
            let account = accounts[index]
            modelContext.delete(account)
        }
    }
}
