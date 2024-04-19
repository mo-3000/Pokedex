//
//  Entities.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import Foundation

struct Pokemon: Codable, Hashable {
    let name: String
    let url: URL
}

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Sprites: Codable, Hashable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

enum StatType: String, Codable {
    case hp = "hp"
    case attack = "attack"
    case defense = "defense"
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed = "speed"
    
    var displayName: String {
        rawValue.capitalized
    }
}

struct Stat: Codable, Hashable {
    let baseStat: Int
    let stat: StatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatInfo: Codable, Hashable {
    let type: StatType
    
    enum CodingKeys: String, CodingKey {
        case type = "name"
    }
}

struct TypeElement: Codable, Hashable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable, Hashable {
    let name: String
}

struct PokemonDetail: Codable, Hashable {
    let id: Int
    let name: String
    let sprites: Sprites
    let abilities: [Ability]
    let moves: [Move]
    let stats: [Stat]
    let types: [TypeElement]
    
    var imageUrl: URL? {
        return URL(string: sprites.frontDefault)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, sprites, abilities, moves, stats, types
    }
    
    static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func statValue(forType type: StatType) -> Int? {
        return stats.first(where: { $0.stat.type == type })?.baseStat
    }
}

struct Ability: Codable, Hashable {
    let abilityInfo: AbilityInfo
    let isHidden: Bool
    
    enum CodingKeys: String, CodingKey {
        case abilityInfo = "ability"
        case isHidden = "is_hidden"
    }
}

struct AbilityInfo: Codable, Hashable {
    let name: String
}

struct Move: Codable, Hashable {
    let moveInfo: MoveInfo
    
    enum CodingKeys: String, CodingKey {
        case moveInfo = "move"
    }
}

struct MoveInfo: Codable, Hashable {
    let name: String
}
