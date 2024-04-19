//
//  PokemonListViewController.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import UIKit
import Combine

class PokemonListViewController: UITableViewController {
    private var viewModel: PokemonListViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: UITableViewDiffableDataSource<Section, PokemonDetail>!
    
    enum Section {
        case main
    }
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeader()
        setupBindings()
        viewModel.loadPokemons()
    }
    
    private func setupTableView() {
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        tableView.rowHeight = 120
        tableView.tableFooterView = UIView()
        
        dataSource = UITableViewDiffableDataSource<Section, PokemonDetail>(tableView: tableView) { (tableView, indexPath, pokemonDetail) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell
            self.viewModel.loadImage(for: pokemonDetail) { image in
                DispatchQueue.main.async {
                    if let image = image {
                        cell?.setImage(image: image)
                    }
                }
            }
            cell?.configure(with: pokemonDetail)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    private func setupBindings() {
        viewModel.$pokemons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pokemons in
                self?.updateSnapshot(pokemons: pokemons)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.presentAlertIfNeeded(with: error)
            }
            .store(in: &cancellables)
    }
    
    private func updateSnapshot(pokemons: [PokemonDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(pokemons)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pokemonDetail = dataSource.itemIdentifier(for: indexPath) else { return }
        navigateToDetails(for: pokemonDetail)
    }
    
    private func navigateToDetails(for pokemon: PokemonDetail) {
        let detailViewModel = PokemonDetailViewModel(pokemon: pokemon)
        let detailViewController = PokemonDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func setupHeader() {
        let headerView = TableHeaderView()
        headerView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100)
    }
    
    private func presentAlertIfNeeded(with error: Error?) {
        guard let error = error else { return }
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
