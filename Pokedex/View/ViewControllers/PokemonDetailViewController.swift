//
//  PokemonDetailViewController.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import UIKit
import Combine
import SnapKit

class PokemonDetailViewController: UIViewController {
    private var viewModel: PokemonDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let headerLabel = UILabel()
    private let nameLabel = UILabel()
    private let typesLabel = UILabel()
    private let statsLabel = UILabel()
    private let pokemonImageView = UIImageView()
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        headerLabel.text = "Pokédex"
        headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        view.addSubview(pokemonImageView)
        view.addSubview(nameLabel)
        view.addSubview(typesLabel)
        view.addSubview(statsLabel)
        
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.clipsToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        
        typesLabel.font = UIFont.boldSystemFont(ofSize: 20)
        typesLabel.numberOfLines = 0
        typesLabel.textAlignment = .center
        
        statsLabel.font = UIFont.systemFont(ofSize: 18)
        statsLabel.numberOfLines = 0
        statsLabel.textAlignment = .center
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        pokemonImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.height.width.equalTo(200)
        }
        
        typesLabel.snp.makeConstraints { make in
            make.top.equalTo(pokemonImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        statsLabel.snp.makeConstraints { make in
            make.top.equalTo(typesLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        viewModel.$pokemon
            .receive(on: RunLoop.main)
            .sink { [weak self] detail in
                self?.updateUI(with: detail)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.presentAlert(for: error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with detail: PokemonDetail?) {
        nameLabel.text = detail?.name
        typesLabel.text = detail?.types.map { $0.type.name }.joined(separator: ", ")
        let statsText = detail?.stats.map { stat in
            "\(stat.stat.type.displayName): \(stat.baseStat)"
        }.joined(separator: "\n")
        statsLabel.text = statsText
        
        viewModel.loadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.pokemonImageView.image = image
            }
        }
    }
    
    private func presentAlert(for error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

