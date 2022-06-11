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
            setAll()
        }
    }
    
    private var text: UILabel {
        let text = UILabel()
        text.font = .systemFont(ofSize: 13)
        text.textColor = .black
        text.textAlignment = .left
        return text
    }
    
    private var secondaryText: UILabel {
        let text = UILabel()
        text.font = .systemFont(ofSize: 11)
        text.textColor = .gray
        text.textAlignment = .left
        return text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(text)
        addSubview(secondaryText)
        
        text.ancor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: frame.size.width / 2, height: 20, enableInsets: false)
        secondaryText.ancor(top: text.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: frame.size.width / 2, height: 20, enableInsets: false)
    }
    
    private func setAll() {
        self.text.text = viewModel.name
        self.secondaryText.text = viewModel.note
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
