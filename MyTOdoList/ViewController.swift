//
//  ViewController.swift
//  MyTOdoList
//
//  Created by t2023-m0099 on 1/5/24.
//
// 제출

import UIKit
import Foundation

class ViewController: UIViewController {
    
    //할 일 목록 테이블 뷰
    @IBOutlet weak var listTableView: UITableView!
    //할 일 추가 버튼
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    //편집 버튼
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //편집 완료 버튼
    var doneButton: UIBarButtonItem?
    
    //할 일 목록 저장하는 배열
    var tasks = [TodoList]() {
        didSet {
            self.saveList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.register(TodoListHeader.self, forHeaderFooterViewReuseIdentifier: TodoListHeader.identi)
        
        //done버튼 구현
        //#selector = 메서드를 식별할 수 있는 고유 이름? struct타입이고 컴파일 타임에 지정
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapedDoneButton))
        
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        self.loadList()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //앱을 껐다 켜도 UserDefaults에 있는 할 일을 다시 불러와줌
        //View가 사라지기전 한번더 저장
        self.saveList()
    }
    
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
        
        //추가 취소 버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { action in
            print("등록 취소")
        })
        
        //추가 버튼
        let add = UIAlertAction(title: "추가", style: .default, handler: { _ in
            
            guard let date = alertController.textFields?[0].text else { return } // 날짜 입력
            guard let title = alertController.textFields?[1].text else { return } // 할 일 입력
            let data = TodoListContent(title: title, done: true)
            if let index = self.tasks.firstIndex(where: {$0.date == date}) {
                self.tasks[index].list.append(data)
            } else {
                self.tasks.append(TodoList(date: date, list: [data]))
            }
            
            self.listTableView.setEditing(false, animated: true)
            self.listTableView.reloadData()
        })
                
        //alert 내의 텍스트 필드 추가
        alertController.addTextField { date in
            date.placeholder = "ex - 24.01.01"
        }
        alertController.addTextField { title in
            title.placeholder = "할 일을 입력하세요."
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
}



extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let tasks = self.tasks[indexPath.row]
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].list.count
    }
    
    //셀 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodoListHeader.identi) as? TodoListHeader else {
//            return UIView()
//        }
//        headerView.setDate(model: tasks[section].date)
//        return headerView
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: -20, width: tableView.frame.width, height: 40))
//        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
//        textLabel.text = tasks[section].date
//        textLabel.textColor = UIColor.lightGray
//        view.addSubview(textLabel)
//        return view
//    }
    
    //header이름
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerName = tasks[section].date
        return "\(headerName)"
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35 // 원하는 헤더 높이로 수정하세요.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //다운캐스팅 공부 좀 더 해보기
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell()}
        cell.setTodoList(tasks[indexPath.section].list[indexPath.row])
        return cell
    }
    
    //tableView(_:commit:forRowAt:) 편집 모드 사용시 해당하는 할 일 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        tasks[indexPath.section].list.remove(at: indexPath.row)
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "tasks")
        
        //헤더 삭제, 섹션 삭제
        tableView.deleteRows(at: [indexPath], with: .fade)
        if tasks[indexPath.section].list.isEmpty {
            tasks.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
        }
        
        if self.tasks.isEmpty {
            self.tapedDoneButton()
        }
        
        print(UserDefaults.standard.string(forKey: "tasks"))
        print(UserDefaults.standard.bool(forKey: "tasks"))
    }
}

