import SwiftUI

struct CryptoDetailView: View {
    @Binding var crypto: Crypto
    @State private var showingEditView = false
    @State private var selectedTransaction: Transaction?
    @State private var showingAddTransactionView = false

    var body: some View {
        VStack {
            HStack {
                Text("\(crypto.symbol)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Text("\(crypto.currentPrice ?? 0, specifier: "%.2f") $")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding()

            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Quantità Totale")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("\(crypto.totalQuantity, specifier: "%.2f")")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.bottom, 10)
                    }
                    .padding(.horizontal)

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("Valore Totale")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("\(crypto.totalValue, specifier: "%.2f") $")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.bottom, 10)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

                VStack {
                    Text("PMedio")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                    Text("\(crypto.averagePurchasePrice, specifier: "%.2f") $")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding()

                VStack {
                    Text("P/L Totale")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                    Text("\(crypto.totalProfitLoss, specifier: "%.2f") $ (\(crypto.totalProfitLossPercentage, specifier: "%.2f")%)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(crypto.totalProfitLoss >= 0 ? .green : .red)
                }
                .padding()
            }
            .padding(.bottom, 20)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach($crypto.transactions) { $transaction in
                        VStack {
                            TransactionCard(transaction: $transaction, currentPrice: crypto.currentPrice)
                                .onTapGesture {
                                    selectedTransaction = transaction
                                    showingEditView = true
                                }
                            Divider() // Aggiunto il separatore
                        }
                    }
                }
                .padding(.horizontal)
            }

            .navigationBarTitle("Dettagli di \(crypto.symbol)", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTransactionView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingEditView) {
                if let selectedTransaction = selectedTransaction {
                    EditTransactionView(transaction: $crypto.transactions[crypto.transactions.firstIndex(where: { $0.id == selectedTransaction.id })!]) {
                        self.selectedTransaction = nil
                    }
                }
            }
            .sheet(isPresented: $showingAddTransactionView) {
                AddTransactionView(onSave: { newTransaction in
                    crypto.transactions.append(newTransaction)
                    showingAddTransactionView = false
                })
            }
        }
    }

    private func deleteTransaction(at offsets: IndexSet) {
        crypto.transactions.remove(atOffsets: offsets)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
}

struct TransactionCard: View {
    @Binding var transaction: Transaction
    var currentPrice: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pacq: \(transaction.purchasePrice, specifier: "%.2f") $")
                    Text("Quantità: \(transaction.quantity, specifier: "%.2f")")
                    Text("Data: \(transaction.purchaseDate, formatter: dateFormatter)")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    let totalSpent = transaction.purchasePrice * transaction.quantity
                    let currentTotalValue = (currentPrice ?? 0) * transaction.quantity
                    let profitLoss = currentTotalValue - totalSpent
                    let profitLossPercentage = (profitLoss / totalSpent) * 100
                    Text("P/L: \(profitLoss, specifier: "%.2f") $")
                        .foregroundColor(profitLoss >= 0 ? .green : .red)
                    Text("(\(profitLossPercentage, specifier: "%.2f")%)")
                        .foregroundColor(profitLossPercentage >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 2))
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
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
