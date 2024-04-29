//
//  PokemonListViewModel.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation
import UIKit

class PokemonListViewModel {
    var apiService: APIServiceProtocol
    var imageLoader: ImageLoader
    @Published var pokemons: [PokemonDetail] = []
    @Published var error: Error?
    
    init(apiService: APIServiceProtocol, imageLoader: ImageLoader = .shared) {
        self.apiService = apiService
        self.imageLoader = imageLoader
    }
    
    func loadImage(for pokemon: PokemonDetail, with completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = pokemon.imageUrl else {
            completion(nil)
            return
        }
        imageLoader.loadImage(from: imageUrl) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func loadPokemons() {
        apiService.fetchAllPokemon { [weak self] result in
            switch result {
            case .success(let pokemonList):
                self?.loadDetailsFor(pokemonList: pokemonList)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
    private func loadDetailsFor(pokemonList: [Pokemon]) {
        let group = DispatchGroup()
        var details: [PokemonDetail] = []
        
        pokemonList.forEach { pokemon in
            group.enter()
            apiService.fetchPokemonInfo(from: pokemon.url) { result in
                switch result {
                case .success(let pokemonDetail):
                    details.append(pokemonDetail)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.error = error
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.pokemons = details.sorted { $0.id < $1.id }
        }
    }
}
