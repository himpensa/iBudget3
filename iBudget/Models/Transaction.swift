//
//  Transaction.swift
//  MyAppController
//
//  Created by Antoine Himpens on 28/10/2023.
//

import SwiftUI
import SwiftData

// Classe de base Transaction
@Model class Transaction : Codable{
    var transaction_id: UUID
    var transaction_details: String
    var transaction_date: Date
    var transaction_amount: Double
    var transaction_payee: Payee?
    var transaction_currency: Currency?
    var transaction_account: Account?
    var transaction_category: Category?
    var transaction_completed: Bool = false
    var plannedTransactionID: UUID? // Identifiant de la transaction planifiée correspondante, optionnel pour les transactions passées


    init(transaction_id: UUID = UUID(), transaction_details: String = "", transaction_date: Date = .now, transaction_amount: Double=0, transaction_currency: Currency? = nil, transaction_account: Account? = nil, transaction_category: Category? = nil, transaction_completed: Bool, transaction_payee: Payee? = nil, plannedTransactionID: UUID? = nil) {
        self.transaction_id = transaction_id
        self.transaction_details = transaction_details
        self.transaction_date = transaction_date
        self.transaction_amount = transaction_amount
        self.transaction_currency = transaction_currency
        self.transaction_account = transaction_account
        self.transaction_category = transaction_category
        self.transaction_completed = transaction_completed
        self.transaction_payee = transaction_payee
    }
    
    func description() -> String {
        return "Transaction [Details: \(transaction_details), Amount: \(transaction_amount), Currency: \(String(describing: transaction_currency)), Account: \(String(describing: transaction_account)), Category: \(String(describing: transaction_category))]"
    }

    func update(transaction_details: String, transaction_date: Date, transaction_amount: Double, transaction_currency: Currency, transaction_account: Account, transaction_category: Category, transaction_completed: Bool, transaction_payee: Payee) {
        self.transaction_details = transaction_details
        self.transaction_date = transaction_date
        self.transaction_amount = transaction_amount
        self.transaction_currency = transaction_currency
        self.transaction_account = transaction_account
        self.transaction_category = transaction_category
        self.transaction_completed = transaction_completed
        self.transaction_payee = transaction_payee
    }
    
    func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transaction_id, forKey: .transaction_id)
        try container.encode(transaction_details, forKey: .transaction_details)
         try container.encode(transaction_date, forKey: .transaction_date)
        try container.encode(transaction_amount, forKey: .transaction_amount)
        try container.encode(transaction_currency, forKey: .transaction_currency)
        try container.encode(transaction_account, forKey: .transaction_account)
        try container.encode(transaction_category, forKey: .transaction_category)
        try container.encode(transaction_completed, forKey: .transaction_completed)
        try container.encode(transaction_payee, forKey: .transaction_payee)
    }
    
    // Implémentation requise de Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transaction_id = try container.decode(UUID.self, forKey: .transaction_id)
        transaction_details = try container.decode(String.self, forKey: .transaction_details)
        transaction_date = try container.decode(Date.self, forKey: .transaction_date)
        transaction_amount = try container.decode(Double.self, forKey: .transaction_amount)
        transaction_completed = try container.decode(Bool.self, forKey: .transaction_completed)
        if let currency = try? container.decode(Currency.self, forKey: .transaction_currency) {
            transaction_currency = currency
        } else {
            transaction_currency = nil // Si la valeur est null dans le JSON, assignez nil à account_currency
        }
        if let account = try? container.decode(Account.self, forKey: .transaction_account) {
            transaction_account = account
        } else {
            transaction_account = nil
        }
        if let category = try? container.decode(Category.self, forKey: .transaction_category) {
            transaction_category = category
        } else {
            transaction_category = Category()
        }
        if let payee = try? container.decode(Payee.self, forKey: .transaction_payee) {
            transaction_payee = payee
        } else {
            transaction_payee = Payee()
        }
    }
    
    // CodingKeys pour associer les propriétés aux clés du JSON/XML
    private enum CodingKeys: String, CodingKey {
        case transaction_id
        case transaction_details
        case transaction_date
        case transaction_amount
        case transaction_currency
        case transaction_account
        case transaction_category
        case transaction_completed
        case transaction_payee
    }
}
