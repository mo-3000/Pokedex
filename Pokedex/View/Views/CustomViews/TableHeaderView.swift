//
//  TableHeaderView.swift
//  Pokédex
//
//  Created by Mohammed Ali on 19/04/2024.
//

import UIKit
import SnapKit

class TableHeaderView: UIView {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.text = "Pokédex"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
