//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Bushmaks on 27.07.2018.
//  Copyright © 2018 Bushmaks. All rights reserved.
//

import UIKit
import M13Checkbox
import Alamofire

var projects: [Project] = []


class TodoListViewController: UITableViewController, CheckboxDelegate {
    
    private func fetchData() {
        Alamofire.request("http://warm-fjord-39817.herokuapp.com/projects.json").responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных\(String(describing: response.result.error))")
                return
            }
            guard let arrayOfProjects = response.result.value as? [[String:AnyObject]]
                else {
                    print("Не могу перевести в массив")
                    return
            }
            // Парсинг JSON
            projects.removeAll()
            for project in arrayOfProjects {
                let todosArray = project["todos"]! as! [[String:AnyObject]]
                var todos: [Todo] = []
                for t in todosArray {
                    let todo = Todo(id: t["id"] as! Int, text: t["text"] as! String, isCompleted: t["isCompleted"] as! Bool, project_id: t["project_id"] as! Int)
                    todos.append(todo)
                }
                let projectObject = Project(title: project["title"] as! String, id: project["id"] as! Int, todos: todos)
                projects.append(projectObject)
            }
            self.tableView.reloadData()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }
    
    
    func didTapCheckbox(state: M13Checkbox.CheckState, sender: M13Checkbox, label: UILabel) {
        let cell = sender.superview?.superview as! TodoTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
        if state == .checked {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            projects[(indexPath?.section)!].todos[(indexPath?.row)!].isCompleted = true
        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            
            projects[(indexPath?.section)!].todos[(indexPath?.row)!].isCompleted = false
        }
        label.attributedText = attributeString
        let parameters: Parameters = [
            "todo": [
                "isCompleted": projects[(indexPath?.section)!].todos[(indexPath?.row)!].isCompleted
            ]
        ]
        let id = projects[(indexPath?.section)!].todos[(indexPath?.row)!].id
        Alamofire.request("http://warm-fjord-39817.herokuapp.com/api/v1/todos/" + String(id), method: .patch, parameters: parameters, encoding: JSONEncoding.default)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if projects.isEmpty {
            return 1
        } else {
           return projects.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numberOfRowsAtSection: [Int] = []
        for project in projects {
            numberOfRowsAtSection.append(project.todos.count)
        }
        
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        
        cell.TodoTextLabel.text = projects[indexPath.section].todos[indexPath.row].text
        cell.delegate = self
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.TodoTextLabel.text!)
        if projects[indexPath.section].todos[indexPath.row].isCompleted {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.CheckBox.setCheckState(.checked, animated: false)
        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            cell.CheckBox.setCheckState(.unchecked, animated: false)
        }
        cell.TodoTextLabel.attributedText = attributeString
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView?
    {
        let section = tableView.dequeueReusableCell(withIdentifier: "Header")
        
        if projects.isEmpty {
            section?.textLabel?.text = "Загрузка..."
        } else {
            section?.textLabel?.text = projects[sectionIndex].title
        }
        
        return section
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 77
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func Refresh(_ sender: UIBarButtonItem) {
        fetchData()
    }

}
