//
//  PokemonDetailViewModel.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation
import UIKit

class PokemonDetailViewModel {
    var imageLoader: ImageLoader
    @Published var pokemon: PokemonDetail?
    @Published var error: Error?
    
    init(pokemon: PokemonDetail, imageLoader: ImageLoader = .shared) {
        self.pokemon = pokemon
        self.imageLoader = imageLoader
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let pokemon = pokemon, let imageUrl = pokemon.imageUrl else {
            completion(nil)
            return
        }
        imageLoader.loadImage(from: imageUrl) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
