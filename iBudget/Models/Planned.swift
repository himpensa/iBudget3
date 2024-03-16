//
//  PlannedTransaction.swift
//  MyAppController
//
//  Created by Antoine Himpens on 16/02/2024.
//

import Foundation
import SwiftData


// Définition de la classe PlannedTransaction
@Model class Planned: Identifiable, Codable {
    var planned_id = UUID()
    var planned_next_date: Date
    var planned_amount: Double
    var planned_description: String
    var planned_recurrence: Recurrence
    var planned_account: Account?
    var planned_currency: Currency?
    var planned_category: Category?
    var planned_payee: Payee?
    var planned_end_date: Date
    var planned_transactions: [Transaction] // Tableau des transactions correspondantes
    
    init(planned_next_date: Date, planned_end_date: Date, planned_recurrence: Recurrence, planned_amount: Double, planned_description: String, planned_currency: Currency?, planned_account: Account?, planned_category: Category?, planned_payee: Payee?, planned_transactions: [Transaction] = []) {
        self.planned_next_date = planned_next_date
        self.planned_amount = planned_amount
        self.planned_description = planned_description
        self.planned_recurrence = planned_recurrence
        self.planned_end_date = planned_end_date
        self.planned_transactions = planned_transactions
        self.planned_account = planned_account
        self.planned_category = planned_category
        self.planned_currency = planned_currency
        self.planned_payee = planned_payee
    }
    
    func description() -> String {
        return "Planned [Details: \(planned_description), Amount: \(planned_amount), Date: \(planned_amount), Currency: \(String(describing: planned_currency!.currency_name)), Account: \(String(describing: planned_account!.account_name)), Category: \(String(describing: planned_category!.category_name))]"
    }
    
    // Méthode pour générer les transactions planifiées en fonction de la récurrence
    func generateTransactions() -> [Transaction] {
        print(planned_next_date)
        print("inside")
        print(planned_end_date)
        print(planned_currency!.currency_name)
        print(planned_account!.account_name)
        print(planned_category!.category_name)
        var transactions = [Transaction]()
        var currentDate = planned_next_date
        
        while currentDate <= planned_end_date {
            print(planned_currency!.currency_name)
            print(planned_account!.account_name)
            print(planned_category!.category_name)
            let transaction = Transaction(transaction_details: planned_description, transaction_date: currentDate, transaction_amount: planned_amount, transaction_currency: planned_currency, transaction_account: planned_account, transaction_category: planned_category, transaction_completed: false, transaction_payee: planned_payee, plannedTransactionID: planned_id)
            print(transaction.description())
            transactions.append(transaction)
            
            // Calcul de la prochaine échéance en fonction de la récurrence
            switch planned_recurrence {
            case .never:
                break
            case .daily:
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            case .weekly:
                currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate)!
            case .monthly:
                currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
            case .yearly:
                currentDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate)!
            }
        }
        
        return transactions
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        planned_id = try values.decode(UUID.self, forKey: .planned_id)
        planned_amount = try values.decode(Double.self, forKey: .planned_amount)
        planned_description = try values.decode(String.self, forKey: .planned_description)
        planned_recurrence = try values.decode(Recurrence.self, forKey: .planned_recurrence)
        planned_next_date=try values.decode(Date.self, forKey: .planned_next_date)
        planned_end_date=try values.decode(Date.self, forKey: .planned_end_date)
        planned_account=try values.decode(Account.self, forKey: .planned_account)
        planned_category=try values.decode(Category.self, forKey: .planned_category)
        planned_currency=try values.decode(Currency.self, forKey: .planned_currency)
        planned_payee=try values.decode(Payee.self, forKey: .planned_payee)
        planned_transactions=[]
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(planned_id, forKey: .planned_id)
        try container.encode(planned_amount, forKey: .planned_amount)
        try container.encode(planned_description, forKey: .planned_description)
        try container.encode(planned_recurrence, forKey: .planned_recurrence)
        try container.encode(planned_next_date, forKey: .planned_next_date)
        try container.encode(planned_end_date, forKey: .planned_end_date)
        try container.encode(planned_payee, forKey: .planned_payee)
    }

    enum CodingKeys: String, CodingKey {
        case planned_id
        case planned_next_date
        case planned_amount
        case planned_description
        case planned_recurrence
        case planned_end_date
        case planned_transactions
        case planned_account
        case planned_category
        case planned_currency
        case planned_payee
    }


}
