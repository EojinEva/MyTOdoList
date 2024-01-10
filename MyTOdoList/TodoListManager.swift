//
//  TodoListManager.swift
//  MyTOdoList
//
//  Created by t2023-m0099 on 1/9/24.
//

import Foundation

class TodoListManager {
    static let shared = TodoListManager()
    private let todoListKey = "myKey"
    private init() {}
    
    
    func saveList(todoList: [TodoList]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(todoList) {
            UserDefaults.standard.set(encodedData, forKey: todoListKey)
        }
    }
    
    func loadList() -> [TodoList] {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.data(forKey: todoListKey),
           let todoList = try? decoder.decode([TodoList].self, from: savedData) {
            return todoList
        }
        return []
    }
}

extension ViewController {
    func saveList() {
        TodoListManager.shared.saveList(todoList: tasks)
    }
    func loadList() {
        self.tasks = TodoListManager.shared.loadList()
    }
}

