import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    var purchasePrice: Double
    var quantity: Double
    var purchaseDate: Date
}
