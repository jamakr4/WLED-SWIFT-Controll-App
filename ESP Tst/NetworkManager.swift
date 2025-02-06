// Responsible for sending HTTP Request to WLED devices

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    func fetchWLEDStatus(for ipAddress: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "http://\(ipAddress)/json") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
