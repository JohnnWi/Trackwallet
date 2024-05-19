import SwiftUI

struct CryptoDetailView: View {
    @Binding var crypto: Crypto
    @State private var showingEditView = false
    @State private var selectedTransaction: Transaction?

    var body: some View {
        VStack {
            Text("\(crypto.symbol)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Prezzo Corrente: \(crypto.currentPrice ?? 0, specifier: "%.2f") $")
                .font(.title2)
                .padding()

            Text("Quantità Totale: \(crypto.totalQuantity, specifier: "%.2f")")
                .padding()

            Text("Prezzo Medio di Acquisto: \(crypto.averagePurchasePrice, specifier: "%.2f") $")
                .padding()

            Text("Valore Totale: \(crypto.totalValue, specifier: "%.2f") $")
                .padding()

            Text("P/L: \(crypto.profitLoss, specifier: "%.2f") $ (\(crypto.profitLossPercentage, specifier: "%.2f")%)")
                .foregroundColor(crypto.profitLoss >= 0 ? .green : .red)
                .padding()

            List {
                ForEach($crypto.transactions) { $transaction in
                    VStack(alignment: .leading) {
                        Text("Prezzo d'Acquisto: \(transaction.purchasePrice, specifier: "%.2f") $")
                        Text("Quantità: \(transaction.quantity, specifier: "%.2f")")
                        Text("Data d'Acquisto: \(transaction.purchaseDate, style: .date)")
                        let profitLoss = (crypto.currentPrice ?? 0 - transaction.purchasePrice) * transaction.quantity
                        let profitLossPercentage = ((crypto.currentPrice ?? 0) / transaction.purchasePrice - 1) * 100
                        Text("P/L: \(profitLoss, specifier: "%.2f") $ (\(profitLossPercentage, specifier: "%.2f")%)")
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                    }
                    .padding()
                    .onTapGesture {
                        selectedTransaction = transaction
                        showingEditView = true
                    }
                }
                .onDelete(perform: deleteTransaction)
            }
            .navigationBarTitle("Dettagli di \(crypto.symbol)", displayMode: .inline)
            .toolbar {
                EditButton()
            }
            .sheet(isPresented: $showingEditView) {
                if let selectedTransaction = selectedTransaction {
                    EditTransactionView(transaction: $crypto.transactions[crypto.transactions.firstIndex(where: { $0.id == selectedTransaction.id })!]) {
                        self.selectedTransaction = nil
                    }
                }
            }
        }
    }

    private func deleteTransaction(at offsets: IndexSet) {
        crypto.transactions.remove(atOffsets: offsets)
    }
}

struct CryptoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoDetailView(crypto: .constant(Crypto(symbol: "BTC", transactions: [
            Transaction(purchasePrice: 30000, quantity: 0.5, purchaseDate: Date()),
            Transaction(purchasePrice: 35000, quantity: 0.3, purchaseDate: Date())
        ], currentPrice: 40000)))
    }
}
