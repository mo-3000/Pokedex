//
//  PokemonDetailViewModel.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation
import UIKit

class PokemonDetailViewModel {
    @Published var pokemon: PokemonDetail?
    @Published var error: Error?
    
    init(pokemon: PokemonDetail) {
        self.pokemon = pokemon
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let pokemon = pokemon, let imageUrl = pokemon.imageUrl else {
            completion(nil)
            return
        }
        ImageLoader.shared.loadImage(from: imageUrl) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
