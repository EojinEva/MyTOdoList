//
//  listTableViewCell.swift
//  MyTOdoList
//
//  Created by t2023-m0099 on 1/5/24.
//

import UIKit


class ListTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ListTableViewCell {
    func setTodoList(_ model : TodoListContent) {
        titleLabel.text = model.title
    }
}
