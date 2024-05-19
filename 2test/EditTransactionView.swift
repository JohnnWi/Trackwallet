import SwiftUI

struct EditTransactionView: View {
    @Binding var transaction: Transaction
    @State private var purchasePrice: String
    @State private var quantity: String
    @State private var purchaseDate: Date

    var onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode

    init(transaction: Binding<Transaction>, onSave: @escaping () -> Void) {
        self._transaction = transaction
        self.onSave = onSave
        self._purchasePrice = State(initialValue: String(transaction.wrappedValue.purchasePrice))
        self._quantity = State(initialValue: String(transaction.wrappedValue.quantity))
        self._purchaseDate = State(initialValue: transaction.wrappedValue.purchaseDate)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dettagli Transazione")) {
                    TextField("Prezzo d'acquisto", text: $purchasePrice)
                        .keyboardType(.decimalPad)
                    TextField("Quantità", text: $quantity)
                        .keyboardType(.decimalPad)
                    DatePicker("Data d'acquisto", selection: $purchaseDate, displayedComponents: .date)
                }

                Button(action: {
                    let formattedPurchasePrice = purchasePrice.replacingOccurrences(of: ",", with: ".")
                    let formattedQuantity = quantity.replacingOccurrences(of: ",", with: ".")
                    
                    if let purchasePrice = Double(formattedPurchasePrice), let quantity = Double(formattedQuantity) {
                        transaction.purchasePrice = purchasePrice
                        transaction.quantity = quantity
                        transaction.purchaseDate = purchaseDate
                        onSave()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Salva")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Modifica Transazione")
        }
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        EditTransactionView(transaction: .constant(Transaction(purchasePrice: 30000, quantity: 0.5, purchaseDate: Date())), onSave: {})
    }
}
