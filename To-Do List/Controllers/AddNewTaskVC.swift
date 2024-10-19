//
//  AddNewTaskVC.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

class AddNewTaskVC: UIViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    // MARK: - VARIABLES AND CONSTANTS
    var dataClosure: ((TaskModel)->())!

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    // MARK: - BUTTON ACTIONS
    @IBAction func addAction(_ sender: UIButton) {
        if titleField.text ?? "" == ""{
            AppToastView.shared.showToast(message: "Please enter a title", toastType: .warning)
        }else if descField.text ?? "" == ""{
            AppToastView.shared.showToast(message: "Please enter description", toastType: .warning)
        }else{
            var priority = "low"
            switch prioritySegment.selectedSegmentIndex{
            case 0:
                priority = "low"
            case 1:
                priority = "medium"
            case 2:
                priority = "high"
            default:
                priority = "low"
            }
            dataClosure(TaskModel(index: 0, title: titleField.text ?? "", desc: descField.text ?? "", dueDate: DateToString(date: dueDatePicker.date), priority: priority))
            self.dismiss(animated: true)
        }
    }

    // MARK: - FUNCTIONS
    func configView(){
        dueDatePicker.minimumDate = Date()
    }

    func DateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
}
