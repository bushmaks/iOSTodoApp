//
//  CreateTodoTableViewController.swift
//  TodoList
//
//  Created by Bushmaks on 27.07.2018.
//  Copyright © 2018 Bushmaks. All rights reserved.
//

import UIKit
import Alamofire

class CreateTodoTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    var selectedProject = 0
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRowsAtSection: [Int] = [1, Projects.count]
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView?
    {
        let section = tableView.dequeueReusableCell(withIdentifier: "header")

        if sectionIndex == 0 {
            section?.textLabel?.text = "Задача"
        } else {
            section?.textLabel?.text = "Категория"
        }
        
        return section
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell..
        if (indexPath.section == 0)
        {
            let textCell = tableView.dequeueReusableCell(withIdentifier: "CreateTodoText") as! CreateTodoTableViewCell
            return textCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
            cell.textLabel?.text = Projects[indexPath.row].Title
            
            if (indexPath.row == 0) {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.top)
                selectedProject = indexPath.row
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = UIColor.gray.cgColor
            }
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 0) {
            return 88
        } else {
            return 77
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section != 0) {
            selectedProject = indexPath.row
            let cell = tableView.cellForRow(at: indexPath)
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if (indexPath.section != 0) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.layer.borderWidth = 0.0
        }
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    public var todoText = ""
    @IBAction func doneButton(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? CreateTodoTableViewCell
        
        if cell?.field.text != "" {
            todoText = (cell?.field.text)!
            
            let parameters: Parameters = [
                "todo": [
                    "text": todoText,
                    "project_id": selectedProject + 1
                ]
            ]
            
            Alamofire.request("http://warm-fjord-39817.herokuapp.com/api/v1/todos", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка!", message: "Вы не ввели текст задачи", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

