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

var Projects: [Project] = []


class TodoListViewController: UITableViewController, CheckboxDelegate {
    
    func fetchData() {
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
            Projects.removeAll()
            for project in arrayOfProjects {
                let todosArray = project["todos"]! as! [[String:AnyObject]]
                var Todos: [Todo] = []
                for t in todosArray {
                    let todo = Todo(Id: t["id"] as! Int, Text: t["text"] as! String, isCompleted: t["isCompleted"] as! Bool, project_id: t["project_id"] as! Int)
                    Todos.append(todo)
                }
                let projectObject = Project(Title: project["title"] as! String, Id: project["id"] as! Int, Todos: Todos)
                Projects.append(projectObject)
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
            
            Projects[(indexPath?.section)!].Todos[(indexPath?.row)!].isCompleted = true
        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            
            Projects[(indexPath?.section)!].Todos[(indexPath?.row)!].isCompleted = false
        }
        label.attributedText = attributeString
        let parameters: Parameters = [
            "todo": [
                "isCompleted": Projects[(indexPath?.section)!].Todos[(indexPath?.row)!].isCompleted
            ]
        ]
        let id = Projects[(indexPath?.section)!].Todos[(indexPath?.row)!].Id
        Alamofire.request("http://warm-fjord-39817.herokuapp.com/api/v1/todos/" + String(id), method: .patch, parameters: parameters, encoding: JSONEncoding.default)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if Projects.isEmpty {
            return 1
        } else {
           return Projects.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numberOfRowsAtSection: [Int] = []
        for project in Projects {
            numberOfRowsAtSection.append(project.Todos.count)
        }
        
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        
        cell.TodoTextLabel.text = Projects[indexPath.section].Todos[indexPath.row].Text
        cell.delegate = self
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.TodoTextLabel.text!)
        if Projects[indexPath.section].Todos[indexPath.row].isCompleted {
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
        
        if Projects.isEmpty {
            section?.textLabel?.text = "Загрузка..."
        } else {
            section?.textLabel?.text = Projects[sectionIndex].Title
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
