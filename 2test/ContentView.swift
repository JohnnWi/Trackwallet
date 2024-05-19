import SwiftUI

struct ContentView: View {
    @State private var cryptos: [Crypto] = []
    @State private var showingAddCryptoView = false
    @State private var showingSettingsView = false
    @State private var isEditing = false
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Il mio portafoglio")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("\(totalValue, specifier: "%.2f") $")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 5)
                    .padding(.bottom, 20)

                List {
                    ForEach($cryptos) { $crypto in
                        NavigationLink(destination: CryptoDetailView(crypto: $crypto)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(crypto.symbol)
                                            .font(.headline)
                                        Text("(\(crypto.currentPrice ?? 0, specifier: "%.2f") $)")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                    Text("Quantità: \(crypto.totalQuantity, specifier: "%.2f")")
                                    Text("Valore Totale: \(crypto.totalValue, specifier: "%.2f") $")
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    let profitLoss = crypto.profitLoss
                                    let profitLossPercentage = crypto.profitLossPercentage
                                    Text("P/L: \(profitLoss, specifier: "%.2f") $")
                                        .foregroundColor(profitLoss >= 0 ? .green : .red)
                                    Text("Var: \(profitLossPercentage, specifier: "%.2f")%")
                                        .foregroundColor(profitLossPercentage >= 0 ? .green : .red)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    .onDelete(perform: deleteCrypto)
                }
                .listStyle(PlainListStyle())
                .navigationBarItems(leading: EditButton(), trailing: HStack {
                    Button(action: {
                        showingAddCryptoView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        showingSettingsView = true
                    }) {
                        Image(systemName: "gear")
                    }
                })
                .sheet(isPresented: $showingAddCryptoView) {
                    AddCryptoView { newCrypto in
                        if let index = cryptos.firstIndex(where: { $0.symbol == newCrypto.symbol }) {
                            cryptos[index].transactions.append(contentsOf: newCrypto.transactions)
                        } else {
                            cryptos.append(newCrypto)
                        }
                        fetchCurrentPrice(for: newCrypto)
                        showingAddCryptoView = false
                    }
                }
                .sheet(isPresented: $showingSettingsView) {
                    SettingsView()
                }

                Button(action: {
                    updatePrices()
                }) {
                    Text("Aggiorna Prezzi")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }

    private var totalValue: Double {
        cryptos.reduce(0) { $0 + ($1.currentPrice ?? 0) * $1.totalQuantity }
    }

    private func fetchCurrentPrice(for crypto: Crypto) {
        CryptoService.shared.fetchCryptoData(for: crypto.symbol) { result in
            switch result {
            case .success(let currentPrice):
                if let index = cryptos.firstIndex(where: { $0.id == crypto.id }) {
                    cryptos[index].currentPrice = currentPrice
                }
            case .failure(let error):
                print("Failed to fetch current price: \(error)")
            }
        }
    }

    private func updatePrices() {
        for crypto in cryptos {
            fetchCurrentPrice(for: crypto)
        }
    }

    private func deleteCrypto(at offsets: IndexSet) {
        cryptos.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
