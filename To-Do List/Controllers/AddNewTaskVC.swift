//
//  AddNewTaskVC.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

class AddNewTaskVC: UIViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var priorityTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    // MARK: - VARIABLES AND CONSTANTS
    var dataClosure: ((TaskModel)->())!
    var deletedClosure: (()->())!
    var updatedClosure: ((TaskModel)->())!
    var existingData:TaskModel?

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    // MARK: - BUTTON ACTIONS
    @IBAction func addAction(_ sender: UIButton) {
        if titleField.text ?? "" == ""{
            AppToastView.shared.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "PleaseEnterTitle", comment: ""), toastType: .warning)
        }else if descField.text ?? "" == ""{
            AppToastView.shared.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "PleaseEnterDescription", comment: ""), toastType: .warning)
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
            if let data = existingData{
                CoreDataManager.shared.updateTask(id: data.id, newTitle: titleField.text ?? "", newDescription: descField.text ?? "", newDueDate: DateToString(date: dueDatePicker.date), newPriority: priority, index: data.index)
                updatedClosure(TaskModel(id: data.id, index: data.index, title: titleField.text ?? "", desc: descField.text ?? "", dueDate: DateToString(date: dueDatePicker.date), priority: priority))
            }else{
                dataClosure(TaskModel(id: UUID().uuidString, index: 0, title: titleField.text ?? "", desc: descField.text ?? "", dueDate: DateToString(date: dueDatePicker.date), priority: priority))
            }
            self.dismiss(animated: true)
        }
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        CoreDataManager.shared.deleteTask(id: existingData?.id ?? "")
        deletedClosure()
        self.dismiss(animated: true)
    }
    
    // MARK: - FUNCTIONS
    func configView(){
        pageTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "AddNewTask", comment: "")
        titleField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Title", comment: "")
        descField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Description", comment: "")
        priorityTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "TaskPriority", comment: "")
        dateTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SelectDueDate", comment: "")
        deleteButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete", comment: ""), for: .normal)
        prioritySegment.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Low", comment: ""), forSegmentAt: 0)
        prioritySegment.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Medium", comment: ""), forSegmentAt: 1)
        prioritySegment.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "High", comment: ""), forSegmentAt: 2)

        dueDatePicker.minimumDate = Date()
        deleteButton.isHidden = true
        addButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add", comment: ""), for: .normal)
        if let data = existingData{
            deleteButton.isHidden = false
            addButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Update", comment: ""), for: .normal)
            titleField.text = data.title
            descField.text = data.desc
            switch data.priority{
            case "low":
                prioritySegment.selectedSegmentIndex = 0
            case "medium":
                prioritySegment.selectedSegmentIndex = 1
            case "high":
                prioritySegment.selectedSegmentIndex = 2
            default:
                prioritySegment.selectedSegmentIndex = 0
            }
            dueDatePicker.date = convertStringToDate(dateString: data.dueDate)
        }
    }

    func convertStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        return dateFormatter.date(from: dateString) ?? Date()
    }

    func DateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
}
