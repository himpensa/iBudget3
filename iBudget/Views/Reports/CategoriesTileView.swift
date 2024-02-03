import SwiftUI
import Charts

struct CategoriesTileView: View {
    var body: some View {
                    HStack {
                        DonutChart()
                            .frame(width: 100, height: 100)
                        
                        VStack(alignment: .leading) {
                            ExpenseRow(category: "Alimentation", percentage: 10)
                            ExpenseRow(category: "Logement", percentage: 7)
                            ExpenseRow(category: "Loisirs", percentage: 12)
                }
            }
    }
}

let data = [
    (category: "Cachapa", amount: 9631),
    (category: "Crêpe", amount: 6959),
    (category: "Injera", amount: 4891),
    (category: "Jian Bing", amount: 2506),
    (category: "American", amount: 1777),
    (category: "Dosa", amount: 625),
]

struct DonutChart: View {
    var body: some View {
        Chart(data, id: \.category) { category, amount in
            SectorMark(
                angle: .value("Value", amount),
                innerRadius: .ratio(0.618),
                outerRadius: .inset(10),
                angularInset: 1
            )
            .cornerRadius(4)
            .foregroundStyle(by: .value("Product category", category))
            
        }.chartLegend(.hidden)

    }
}

struct ExpenseRow: View {
    var category: String
    var percentage: Double
    
    var body: some View {
        HStack {
            Text(category)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("%\(percentage, specifier: "%.2f")")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 1)
    }
}

struct CategoriesTileView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesTileView()
    }
}