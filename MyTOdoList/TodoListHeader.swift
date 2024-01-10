//
//  TodoListHeader.swift
//  MyTOdoList
//
//  Created by t2023-m0099 on 1/10/24.
//

import Foundation
import UIKit

class TodoListHeader: UITableViewHeaderFooterView {
    static let identi = "HeaderIdenti"
    
    let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setAddView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension TodoListHeader {
    func setAddView() {
        addSubview(titleLabel)
    }

    
    func setDate(model: String){
        titleLabel.text = model
    }
}
