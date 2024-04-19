//
//  PokemonCell.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import UIKit
import SnapKit

class PokemonCell: UITableViewCell {
    static let identifier = "PokemonCell"
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(nameLabel)
        
        pokemonImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(100)
            make.top.equalToSuperview().offset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(pokemonImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    func configure(with pokemon: PokemonDetail) {
        nameLabel.text = pokemon.name
    }
    
    func setImage(image: UIImage) {
        pokemonImageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonImageView.image = nil
        nameLabel.text = nil
    }
}

