//
//  QIFDataContainer.swift
//  iBudget
//
//  Created by Antoine Himpens on 19/01/2024.
//

import Foundation
import SwiftUI
import SwiftData

class QIFDataContainerImporter {
    var transactions: [Transaction] = []


    func importQIF(from fileURL: URL, selectedCurrency: Currency?, selectedAccount: Account?, defaultCategory: Category?) {
        fileURL.startAccessingSecurityScopedResource()

      //  let qifString = try? String(contentsOf: fileURL)

        do  {
            let qifString = try String(contentsOf: fileURL)
            let lines = qifString.split(separator: "\n")
            var date: Date?
            var amount: Double?
            var description: String?

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            for line in lines {
                if line.hasPrefix("D") {
                    date = dateFormatter.date(from: String(line.dropFirst()))
                } else if line.hasPrefix("T") {
                    amount = Double(line.dropFirst())
                } else if line.hasPrefix("P") {
                    description = String(line.dropFirst())
                } else if line == "^" {
                    if let date = date, let amount = amount, let description = description {
                        print(description)
                        let transaction = Transaction(transaction_details: description, transaction_date: date, transaction_amount: amount, transaction_currency: selectedCurrency,transaction_account: selectedAccount,transaction_category: defaultCategory ?? Category(), transaction_completed: true)
                        transactions.append(transaction)
                    }
                    date = nil
                    amount = nil
                    description = nil
                    print(defaultCategory?.category_name)
                    print(transactions.first?.transaction_details)
                }
            }
        } catch {
            print("Erreur lors de la lecture du fichier : \(error)")
        }
        fileURL.stopAccessingSecurityScopedResource()
        
    }
}



