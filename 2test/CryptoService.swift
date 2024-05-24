import Foundation

class CryptoService {
    static let shared = CryptoService()
    private let apiKey = "x"
    private let baseUrl = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"

    func fetchCryptoData(for symbol: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)?symbol=\(symbol)&CMC_PRO_API_KEY=\(apiKey)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let quote = (json?["data"] as? [String: Any])?[symbol] as? [String: Any],
                   let price = (quote["quote"] as? [String: Any])?["USD"] as? [String: Any],
                   let currentPrice = price["price"] as? Double {
                    completion(.success(currentPrice))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
