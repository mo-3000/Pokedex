//
//  Poke_dexTests.swift
//  PokédexTests
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation
import XCTest
import Pokedex

class PokemonViewModelTests: XCTestCase {
    var listViewModel: PokemonListViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        listViewModel = PokemonListViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        mockAPIService = nil
        listViewModel = nil
        super.tearDown()
    }
    
    func testLoadPokemonSuccess() {
        let pokemons = [Pokemon(name: "Bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)]
        let pokemonDetail = PokemonDetail(
            id: 1,
            name: "Bulbasaur",
            sprites: Sprites(frontDefault: "https://sample.com/image.png"),
            abilities: [Ability(abilityInfo: AbilityInfo(name: "Overgrow"), isHidden: false)],
            moves: [Move(moveInfo: MoveInfo(name: "Tackle"))],
            stats: [Stat(baseStat: 45, stat: StatInfo(type: .hp))],
            types: [TypeElement(slot: 1, type: TypeInfo(name: "grass"))]
        )
        mockAPIService.getAllPokemonResult = .success(pokemons)
        mockAPIService.getPokemonDetailResult[URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!] = .success(pokemonDetail)
        
        let expectation = self.expectation(description: "Loading Pokemon")
        
        listViewModel.loadPokemons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertEqual(self.listViewModel.pokemons.count, 1)
            XCTAssertEqual(self.listViewModel.pokemons.first?.name, "Bulbasaur")
            XCTAssertNil(self.listViewModel.error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    
    func testLoadPokemonFailure() {
        let error = NSError(domain: "APIService", code: -1001, userInfo: [NSLocalizedDescriptionKey: "Network connection lost"])
        mockAPIService.getAllPokemonResult = .failure(error)
        
        let expectation = self.expectation(description: "Loading Pokemon with Error")
        
        listViewModel.loadPokemons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(self.listViewModel.pokemons.isEmpty)
            XCTAssertEqual(self.listViewModel.error?.localizedDescription, "Network connection lost")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
}
