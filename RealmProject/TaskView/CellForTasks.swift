//
//  CellForTasks.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 11/06/2022.
//

import UIKit

class CellForTasks: UITableViewCell {
    
    var viewModel: CellForTaskProtocol! {
        didSet {
            text.text = viewModel.name
            text.font = .systemFont(ofSize: 17)
            text.textColor = .black
            text.frame.size.height = 20
            
            secondaryText.text = viewModel.note
            secondaryText.font = .systemFont(ofSize: 14)
            secondaryText.textColor = .gray
            secondaryText.frame.size.height = 20
        }
    }
    
    private let stackView = UIStackView()
    private let text = UILabel()
    private let secondaryText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setupConstraints()
    }
    
    private func setUI() {
        stackView.addArrangedSubview(text)
        stackView.addArrangedSubview(secondaryText)
        stackView.spacing = frame.height * 0.01
        stackView.alignment = .leading
        stackView.axis = .vertical
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: frame.width * 0.07),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: frame.height * 0.05)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
