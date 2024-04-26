//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Maks Vogtman on 25/04/2024.
//

import Foundation

// Singleton makes it globally accessabale throughout the whole app.
class NetworkManager {
    
// The static keyword is used to define properties and methods that belong to the class or struct itself rather than to an instance of the class or struct. They can be accessed using the class or struct name without needing an instance. Thanks to static, you can use NetworkManager.shared
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    
// Part of the things with Singleton is that you want to restrict it so that can be only ONE instance of it - Singleton (it's in the name).
    
// To do that, you make the init private, so it can only be called here.
    
// Essentially this little bit of code is what creates the Signleton.
    private init() {}
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
// Now you have a solid URL, that you can start writing URLSession Data Task, to actually get the information back from the URL.
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
// The data is actually the JSON, that we're getting back.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
// Here, there are two checks: 1. Check if response isn't a nil. 2. If it's not, check the statusCode.
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
// Decoder is taking data FROM the server, and coding it into your objects.
// Encoder is taking your objects, and converting it to data.
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
// You want to create an array of followers. You have to use try, couse decode method throws. You want to decode the data, that you've made couple of lines above, into a type of an array of followers.
                let followers = try decoder.decode([Follower].self, from: data)
// If that goes well, you're gonna call a completion handler, where you pass in the followers array, and not passing the error message, couse that's nil.
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }

// This actually starts the Network Call.
        task.resume()
    }
}
