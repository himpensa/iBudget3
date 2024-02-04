import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct ImportTransactionsViews: View {
    @State private var isQIFFilePickerPresented = false
    @State private var isOFXFilePickerPresented = false
    @Query var transactions: [Transaction]
    @Environment(\.modelContext) var modelContext
    @State private var path = [Transaction]()
    @Query(sort: [SortDescriptor(\Currency.currency_name)]) var currencies: [Currency]
    @Query var accounts: [Account]  // Récupérer la liste des comptes
    @State private var selectedCurrency: Currency?
    @State private var selectedAccount: Account?
   
    
    var body: some View {
        VStack {
            
            Section(header: Text("Currency for the import")) {
                currencyPicker
            }
            Section(header: Text("Account for the import")) {
                accountPicker
            }
            Section(header: Text("Type of Import")) {
                Button("Importer un fichier QIF") {
                    isQIFFilePickerPresented = true
                }
            }
            Section(header: Text("Type of Import")) {
                Button("Importer un fichier OFX") {
                    isOFXFilePickerPresented = true
                }
            }
        }
        .fileImporter(isPresented: $isQIFFilePickerPresented, allowedContentTypes: [UTType(filenameExtension: "qif")!]) { result in
            switch result {
            case .success(let url):
                importQIF(from: url)
            case .failure(let error):
                print("Erreur lors de l'importation du fichier : \(error)")
            }
        }
        .fileImporter(isPresented: $isOFXFilePickerPresented, allowedContentTypes: [UTType(filenameExtension: "ofx")!]) { result in
                   switch result {
                   case .success(let url):
                       importOFX(from: url)
                   case .failure(let error):
                       print("Erreur lors de l'importation du fichier OFX : \(error)")
                   }
               }
    }
    
    private var currencyPicker: some View {
        Picker(selection: $selectedCurrency, label: Text("Currency")) {
            if currencies.isEmpty {
                // If currencies array is empty, show a default value
                Text("Sélectionnez").tag(nil as Currency?)
            } else {
                ForEach(currencies, id: \.self) { currency in
                    Text(currency.currency_name).tag(currency as Currency?)
                }
            }
        }
        .onAppear {
            if currencies.isEmpty {
                // If currencies array is empty, set the default value to nil
                selectedCurrency = nil
            } else {
                selectedCurrency = currencies.first { $0.currency_is_default }
            }
        }
    }

    private var accountPicker: some View {
        Picker(selection: $selectedAccount, label: Text("Account")) {
            if accounts.isEmpty {
                // If accounts array is empty, show a default value
                Text("Sélectionnez").tag(nil as Account?)
            } else {
                ForEach(accounts, id: \.self) { account in
                    Text(account.account_name).tag(account as Account?)
                }
            }
        }
        .onAppear {
            if currencies.isEmpty {
                // If currencies array is empty, set the default value to nil
                selectedCurrency = nil
            } else {
                selectedCurrency = currencies.first { $0.currency_is_default }
            }
        }
    }
    
    func importQIF(from fileURL: URL){
        let qifImporter = QIFDataContainerImporter()
       
        qifImporter.importQIF(from: fileURL, selectedCurrency: selectedCurrency, selectedAccount: selectedAccount)
        
        // Note: You may want to update your data source instead of printing here
        for transaction in qifImporter.transactions {
            modelContext.insert(transaction)
            path = [transaction]
        }
    }
    
    func importOFX(from fileURL: URL){
        let qifImporter = QIFDataContainerImporter()
       
        qifImporter.importQIF(from: fileURL, selectedCurrency: selectedCurrency, selectedAccount: selectedAccount)
        
        // Note: You may want to update your data source instead of printing here
        for transaction in qifImporter.transactions {
            modelContext.insert(transaction)
            path = [transaction]
        }
    }
                
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Currency.self, Account.self, configurations: config)

     let sampleCurrency = Currency(currency_name: "US Dollar", currency_symbol: "$", currency_alphabetic_code: "USD", currency_numeric_code: "840", currency_minor_unit: 2, currency_is_default: false)

    let sampleAccount = Account(account_name: "Courant", account_description: "Compte Courant", account_currency: sampleCurrency, account_type: "Chèque", starting_balance: 0, is_opened: true, account_is_default: true, transactions: [])

    return ImportTransactionsViews()
        .modelContainer(container)

}


