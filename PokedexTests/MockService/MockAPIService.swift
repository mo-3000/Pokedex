//
//  MockAPIService.swift
//  PokédexTests
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation
import Pokedex

class MockAPIService: APIServiceProtocol {
    var getAllPokemonResult: Result<[Pokemon], Error>?
    var getPokemonDetailResult: [URL: Result<PokemonDetail, Error>] = [:]
    
    func fetchAllPokemon(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        if let result = getAllPokemonResult {
            simulateNetworkResponse(result, completion: completion)
        }
    }
    
    func fetchPokemonInfo(from url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        if let result = getPokemonDetailResult[url] {
            simulateNetworkResponse(result, completion: completion)
        }
    }
    
    private func simulateNetworkResponse<T>(_ result: Result<T, Error>, completion: @escaping (Result<T, Error>) -> Void) {
        // Simulated network delay.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
