//
//  Task.swift
//  MyTOdoList
//
//  Created by t2023-m0099 on 1/5/24.
//

import Foundation
import UIKit


struct TodoList: Codable {
    var date: String
    var list: [TodoListContent]
}

struct TodoListContent: Codable {
    var title: String
    var done: Bool
}
