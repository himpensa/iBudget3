import SwiftUI
import SwiftData

struct TransactionsTileView: View {
    @Query(sort: \Transaction.transaction_date, order: .reverse) var transactions: [Transaction]

    var limitedTransactions: [Transaction] {
        return Array(transactions.prefix(3))
    }
    
    
    var body: some View {
            VStack() {
                ForEach(limitedTransactions, id: \.self) { transaction in
                    TransactionRow(categoryColor: Color.blue, transactionTitle: transaction.transaction_details, transactionAmount: transaction.transaction_amount, transactionCurrency: transaction.transaction_currency ?? Currency(),
                        transactionDate: "26/01")
                }
            }
    }
}

struct TransactionRow: View {
    var categoryColor: Color
    var transactionTitle: String
    var transactionAmount: Double
    var transactionCurrency: Currency
    var transactionDate: String
    
    var body: some View {
        HStack() {
            Rectangle()
                .fill(categoryColor)
                .frame(width: 5, height: 30, alignment: .leading)
            
                Text(transactionTitle)
                
            Spacer()
            
            Text(String(transactionAmount))
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(String(transactionCurrency.currency_symbol))
                .font(.subheadline)
                .foregroundColor(.secondary)
      
            Text(transactionDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
    }
}

struct TransactionsTileView_Previews: PreviewProvider {
    static var previews: some View {
        PlannedTileView()
    }
}
