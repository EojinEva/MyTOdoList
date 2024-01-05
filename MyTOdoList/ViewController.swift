//
//  ViewController.swift
//  MyTOdoList
//
//  Created by t2023-m0099 on 1/5/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var add: UIBarButtonItem?

    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        self.loadTasks()
        view.addSubview(listTableView)
        // Do any additional setup after loading the view.
    }
    //할 일 등록 버튼 액션
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        //할 일 등록 버튼 누르면 뜨는 alert창
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        //추가 버튼
        let add = UIAlertAction(title: "추가", style: .default, handler: { action in
            guard let title = alertController.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self.tasks.append(task)
            self.listTableView.reloadData()
            
            print("할 일 추가 완료")})
        //추가 취소 버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { action in
            print("할 일 등록 취소")})
        
        
        //alert 내의 텍스트 필드 추가
        alertController.addTextField { textField in
            textField.placeholder = "To Do List"
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
}
    
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        
    }
}
    

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        self.tasks.remove(at: indexPath.row)
//        listTableView.deleteRows(at: [indexPath], with: .automatic)
//    }
    
    
}

