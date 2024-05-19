import SwiftUI

struct AddCryptoView: View {
    @State private var symbol: String = ""
    @State private var purchasePrice: String = ""
    @State private var quantity: String = ""
    @State private var purchaseDate: Date = Date()

    var onSave: (Crypto) -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dettagli Cripto")) {
                    TextField("Simbolo", text: $symbol)
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
                        let transaction = Transaction(purchasePrice: purchasePrice, quantity: quantity, purchaseDate: purchaseDate)
                        let newCrypto = Crypto(symbol: symbol.uppercased(), transactions: [transaction])
                        onSave(newCrypto)
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
            .navigationTitle("Aggiungi Cripto")
        }
    }
}

struct AddCryptoView_Previews: PreviewProvider {
    static var previews: some View {
        AddCryptoView(onSave: { _ in })
    }
}
