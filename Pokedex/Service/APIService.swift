//
//  APIService.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation

class APIService: APIServiceProtocol {
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon/"
    
    func fetchAllPokemon(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let result: Result<PokemonList, Error> = self.parseResponse(data: data, error: error)
            DispatchQueue.main.async {
                completion(result.flatMap { .success($0.results) })
            }
        }.resume()
    }
    
    func fetchPokemonInfo(from url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            let result: Result<PokemonDetail, Error> = self.parseResponse(data: data, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
    
    private func parseResponse<T: Decodable>(data: Data?, error: Error?) -> Result<T, Error> {
        if let error = error {
            return .failure(error)
        }
        guard let data = data else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
        }
        do {
            let responseData = try JSONDecoder().decode(T.self, from: data)
            return .success(responseData)
        } catch {
            return .failure(error)
        }
    }
}
