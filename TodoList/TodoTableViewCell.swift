//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by Bushmaks on 29.07.2018.
//  Copyright © 2018 Bushmaks. All rights reserved.
//

import UIKit
import M13Checkbox

protocol CheckboxDelegate {
    func didTapCheckbox(state: M13Checkbox.CheckState, sender: M13Checkbox, label: UILabel)
}

class TodoTableViewCell: UITableViewCell {
    
    var delegate: CheckboxDelegate?
    
    @IBOutlet weak var ContentView: UIView!
    
    @IBOutlet weak var TodoTextLabel: UILabel!
    
    @IBOutlet weak var CheckBox: M13Checkbox!
    
    @IBAction func CheckBoxToggle(_ sender: M13Checkbox) {
        delegate?.didTapCheckbox(state: sender.checkState, sender: sender, label: TodoTextLabel)
    }

}
