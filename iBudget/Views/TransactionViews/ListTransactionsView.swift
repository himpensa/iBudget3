import SwiftUI
import SwiftData

struct ListTransactionsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Transaction.transaction_date, order: .reverse) var transactions: [Transaction]
    @Query var accounts: [Account]
    @State private var lastDate = DateFormatter().date(from: "2020/01/01") ?? Date()
    @State private var selectedAccount: Account? = nil
    

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(transactions, id: \.self) { transaction in
                        NavigationLink(destination: EditTransactionView(transaction: transaction)) {
                        VStack {
                            HStack {
                                Image(systemName: transaction.transaction_category?.category_icon ?? "default_icon_name")
                                Text(transaction.transaction_details)
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.2f", transaction.transaction_amount))
                                    .font(.headline)

                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteTransaction)
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(trailing: accountPicker)
                .toolbar {
                    Button("Add Transaction", systemImage: "plus", action: addTransaction)
                    Button("Delete All Categories", action: deleteCategories)
                }
            }
        }
    }
    
    private func deleteCategories() {
        for transaction in transactions {
            transaction.transaction_category = nil
        }
    }

    private var accountPicker: some View {
        Picker(selection: $selectedAccount, label: Text("Account")) {
            ForEach(accounts, id: \.self) { account in
                Text(account.account_name).tag(account as Account?)
            }
        }
        .onAppear {
                selectedAccount = accounts.first { $0.account_is_default }
        }
    }

    private func dateFormatted(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    private func addTransaction() {
        let transaction = Transaction(transaction_category: Category(), transaction_completed: true)
        transaction.transaction_account = selectedAccount
        modelContext.insert(transaction)
    }

    private func deleteTransaction(_ indexSet: IndexSet) {
        for index in indexSet {
            let transaction = transactions[index]
            modelContext.delete(transaction)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Category.self, Transaction.self, configurations: config)

    let sampleCategory = Category(category_name: "Restaurant", category_icon: "questionmark.circle", parentID: nil)
    let sampleAccount = Account(account_name: "Courant", account_description: "test", account_currency: nil, account_type: "Cash", starting_balance: 0, is_opened: true, account_is_default: false, transactions: [])
    let sampleTransaction =  Transaction(transaction_details: "dfgfg", transaction_date: .now, transaction_amount: 0, transaction_currency: nil, transaction_account: sampleAccount, transaction_category: sampleCategory, transaction_completed: true)
       
    container.mainContext.insert(sampleTransaction)

    return ListTransactionsView()
        .modelContainer(container)
}
