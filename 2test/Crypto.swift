import Foundation

struct Crypto: Identifiable {
    let id = UUID()
    let symbol: String
    var transactions: [Transaction]
    var currentPrice: Double?
}

extension Crypto {
    var totalQuantity: Double {
        transactions.reduce(0) { $0 + $1.quantity }
    }

    var averagePurchasePrice: Double {
        let totalSpent = transactions.reduce(0) { $0 + $1.purchasePrice * $1.quantity }
        return totalSpent / totalQuantity
    }

    var totalValue: Double {
        (currentPrice ?? 0) * totalQuantity
    }

    var profitLoss: Double {
        (currentPrice ?? 0 - averagePurchasePrice) * totalQuantity
    }

    var profitLossPercentage: Double {
        ((currentPrice ?? 0) / averagePurchasePrice - 1) * 100
    }
}
