//
//  ListTransactionCategoriyView.swift
//  iBudget
//
//  Created by Antoine Himpens on 08/02/2024.
//

import SwiftUI
import SwiftData

struct ListTransactionCategoryView: View {
    enum Scale: String, CaseIterable, Identifiable {
            case day, week, month, year, all
            var id: Self { self }
        }

    @State private var selectedScale: Scale = .month    
    
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Transaction>{ transaction in
        transaction.transaction_category == nil
        }) var transactions: [Transaction]
    @State private var showingSheet = false

    var selectedSector: String?


    // Fonction pour filtrer les transactions en fonction de la sélection de l'échelle
    private func filterTransactions() -> [Transaction] {
        return transactions.filter({ dateRangeForScale(selectedScale).contains($0.transaction_date)})
    }



    // Fonction pour déterminer la plage de dates en fonction de l'échelle sélectionnée
       private func dateRangeForScale(_ scale: Scale) -> ClosedRange<Date> {
           let currentDate = Date()
           switch scale {
           case .day:
               let startOfDay = Calendar.current.startOfDay(for: currentDate)
               return startOfDay...Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
           case .week:
               let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
               return startOfWeek...Calendar.current.date(byAdding: .day, value: 7, to: startOfWeek)!
           case .month:
               let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
               let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
               return startOfMonth...endOfMonth
           case .year:
               let startOfYear = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: currentDate))!
               let endOfYear = Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)!
               return startOfYear...endOfYear
           case .all:
               return .distantPast...Date()
           }
       }

    var body: some View {
        Picker("TimeScale", selection: $selectedScale) {
            ForEach(Scale.allCases) { scale in
                Text(scale.rawValue.capitalized)
            }
        }
       .pickerStyle(.segmented)
        
        if(filterTransactions().isEmpty){
            Text("No transactions for this period")
            }
            
        
        CategoriesChart(transactions: filterTransactions())
        SimpleListTransactionsFromList(transactions: filterTransactions())

    }
    
    
    
}

#Preview {
    ListTransactionCategoryView()
}



