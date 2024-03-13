import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView
        {
            NavigationStack {
                ScrollView {
                    VStack {
                        GroupBox() {
                            AccountWeatherTileView(
                                account_name: "All Accounts",
                                balance: 15430,
                                last_transaction_date: "01/01/2024",
                                forecasted_balance: 200.0
                            )
                        }
                        .groupBoxStyle(PersoGroupBoxStyle(destination: SimpleListTransactions()))
                        
                        GroupBox() {
                            BudgetTileView()
                        }
                        .groupBoxStyle(PersoGroupBoxStyle(destination: ListBudgetsView()))
                        
                        GroupBox() {
                            CategoriesTileView()
                        }
                        .groupBoxStyle(PersoGroupBoxStyle(destination: ListTransactionCategoryView()))
                        
                        GroupBox(label: Label("Planned Expense", systemImage: "calendar")) {
                            PlannedTileView()
                        }
                        .groupBoxStyle(PersoGroupBoxStyle(destination: ListPlannedView()))
                        
                        GroupBox(label: Label("Last Transactions", systemImage: "dollarsign")) {
                          TransactionsTileView()
                        }
                        .groupBoxStyle(PersoGroupBoxStyle(destination: ListTransactionsView()))

                        GroupBox() {
                            AccountWeatherTileView(
                                account_name: "Compte Courant",
                                balance: 150.0,
                                last_transaction_date: "01/01/2024",
                                forecasted_balance: 200.0
                            )
                        }
                        .groupBoxStyle(PersoGroupBoxStyle(destination: SimpleListTransactions()))
                        
                        GroupBox() {
                            AccountWeatherTileView(
                                account_name: "Compte Commun",
                                balance: -50.0,
                                last_transaction_date: "01/01/2024",
                                forecasted_balance: 130.0
                            )
                        }
                        .groupBoxStyle(PersoGroupBoxStyle(destination: SimpleListTransactions()))
                        



                    }
                    .padding()
                }
            }
            .tabItem {
                Label("Summary", systemImage: "house")
            }.tag(1)
            
            
            MenuView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }.tag(2)
            
            MenuCleanup()
                .tabItem {
                    Label("Cleanup", systemImage: "ellipsis")
                }.tag(3)
        }
    }
}

#Preview {
    ContentView()
}
