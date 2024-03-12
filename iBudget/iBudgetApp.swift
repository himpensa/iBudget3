//
//  iBudgetApp.swift
//  iBudget
//
//  Created by Antoine Himpens on 11/11/2023.
//

import SwiftUI
import SwiftData



@main
struct iBudgetApp: App {
        @StateObject private var appSettings = AppInit()
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ Enveloppe.self, Planned.self, Account.self, Category.self, Transaction.self, Currency.self, Payee.self, Tag.self, Budget.self])
    }
}
