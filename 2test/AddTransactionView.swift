import SwiftUI

struct AddTransactionView: View {
    @State private var purchasePrice: String = ""
    @State private var quantity: String = ""
    @State private var purchaseDate: Date = Date()

    var onSave: (Transaction) -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dettagli Transazione")) {
                    TextField("Pacq", text: $purchasePrice)
                        .keyboardType(.decimalPad)
                    TextField("Quantità", text: $quantity)
                        .keyboardType(.decimalPad)
                    DatePicker("Data", selection: $purchaseDate, displayedComponents: .date)
                }

                Button(action: {
                    let formattedPurchasePrice = purchasePrice.replacingOccurrences(of: ",", with: ".")
                    let formattedQuantity = quantity.replacingOccurrences(of: ",", with: ".")
                    
                    if let purchasePrice = Double(formattedPurchasePrice), let quantity = Double(formattedQuantity) {
                        let newTransaction = Transaction(purchasePrice: purchasePrice, quantity: quantity, purchaseDate: purchaseDate)
                        onSave(newTransaction)
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
            .navigationTitle("Aggiungi Transazione")
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(onSave: { _ in })
    }
}
