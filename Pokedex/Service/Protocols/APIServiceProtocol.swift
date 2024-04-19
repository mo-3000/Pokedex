//
//  APIServiceProtocol.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation

protocol APIServiceProtocol {
    func fetchAllPokemon(completion: @escaping (Result<[Pokemon], Error>) -> Void)
    func fetchPokemonInfo(from url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void)
}
