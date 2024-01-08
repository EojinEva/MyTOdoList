//
//  ViewController.swift
//  MyTOdoList
//
//  Created by t2023-m0099 on 1/5/24.
//
//

import UIKit

class ViewController: UIViewController {
    
    //할 일 목록 테이블 뷰
    @IBOutlet weak var listTableView: UITableView!
    //할 일 추가 버튼
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    //편집 버튼
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //편집 완료 버튼
    var doneButton: UIBarButtonItem?
    var updateButton: UIBarButtonItem?
    
    
    //할 일 목록 저장하는 배열
    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //done버튼 구현
        //#selector = 메서드를 식별할 수 있는 고유 이름? struct타입이고 컴파일 타임에 지정
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapedDoneButton))
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        //앱을 껐다 켜도 UserDefaults에 있는 할 일을 다시 불러와줌
        self.loadTasks()
    }
    
    //done 버튼 누르면
    @objc func tapedDoneButton() {
        self.navigationItem.rightBarButtonItem = self.editButton
        //done 버튼을 누르면 edit모드 해제
        self.listTableView.setEditing(false, animated: true)
    }
    
    
    @IBAction func tapedEditButton(_ sender: UIBarButtonItem) {
        //tasks 배열이 비어있으면 편집모드가 뜨지 않음
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.rightBarButtonItem = self.doneButton
        //setEditing: 편집 모드 진입, 해제시 애니메이션을 보여줌
        self.listTableView.setEditing(true, animated: true)
    }
    
    
    //할 일 등록 버튼 액션
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        //할 일 등록 버튼 누르면 뜨는 alert창
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        //추가 버튼
        let add = UIAlertAction(title: "추가", style: .default, handler: { action in
            guard let title = alertController.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            //추가 버튼을 누르면 tasks배열에 할 일 목록 추가됨
            self.tasks.append(task)
            self.listTableView.setEditing(false, animated: true)
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
    
    //tasks 배열을 UserDefaults에 저장
    //무지성 매핑 수정 필요
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        //UserDefaults를 이용하기 위해 UserDefaults.standard를 호출
        let userDefaults = UserDefaults.standard
        //값 저장
        userDefaults.set(data, forKey: "tasks")
    }
    
    //UserDefaults에서 tasks배열을 불러오기
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
    
    func deleteTasks() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "tasks")
    }
    
    
}
    
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let tasks = self.tasks[indexPath.row]
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
    
    
    //tableView(_:commit:forRowAt:) 편집 모드 사용시 해당하는 할 일 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
//        let userDefaults = UserDefaults.standard
//        userDefaults.removeObject(forKey: "tasks")
        
        print(UserDefaults.standard.string(forKey: "tasks"))
        print(UserDefaults.standard.bool(forKey: "tasks"))
        
        listTableView.deleteRows(at: [indexPath], with: .automatic)
        if self.tasks.isEmpty {
            self.tapedDoneButton()
        }
    }
}

