//
//  ToDoListVC.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

class ToDoListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate{
    // MARK: - IBOUTLETS
    @IBOutlet weak var itemsCV: UICollectionView!

    // MARK: - VARIABLES AND CONSTANTS
    var viewModel: ToDoListVM = ToDoListVM()
    let activityIndicator = ActivityIndicator()
    var toDoItemsArray:[TaskModel] = []

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }

    // MARK: - BUTTON ACTIONS
    @IBAction func addNewAction(_ sender: UIButton) {
        let nextVC = AppController.shared.addNewTask
        if let presentationController = nextVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        nextVC.dataClosure = { data in
            CoreDataManager.shared.createTask(title: data.title, desc: data.desc, dueDate: data.dueDate, priority: data.priority, index: 0)
            self.toDoItemsArray.insert(data, at: 0)
            for i in 0..<self.toDoItemsArray.count{
                self.toDoItemsArray[i].index = Int64(i)
            }
            CoreDataManager.shared.updateAllTaskIndexes(currentArray: self.toDoItemsArray)
            self.itemsCV.reloadData()
        }
        self.present(nextVC, animated: true)
    }
    

    // MARK: - FUNCTIONS
    func configView(){
        ItemCVC.register(for: itemsCV)
        itemsCV.delegate = self
        itemsCV.dataSource = self
        itemsCV.dragDelegate = self
        itemsCV.dropDelegate = self
        itemsCV.dragInteractionEnabled = true
        viewModel.fetchTasks()
    }

    func bindViewModel() {
        viewModel.isLoadingData.bind { [weak self] isLoading in
            guard let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.show()
                } else {
                    self?.activityIndicator.hide()
                }
            }
        }

        viewModel.showError.bind { message in
            guard let message = message else {
                return
            }
            AppToastView.shared.showToast(message: message, toastType: .error)
        }

        viewModel.taskItems.bind { [weak self] taskItems in
            guard let taskItems = taskItems else {
                return
            }
            DispatchQueue.main.async {
                self?.toDoItemsArray = taskItems
                self?.itemsCV.reloadData()
            }
        }
    }

    // MARK: - COLLECTION VIEWS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: itemsCV.frame.width, height:  100)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toDoItemsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = toDoItemsArray[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCVC_id", for: indexPath) as! ItemCVC
        cell.setCellData(data: cellData)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let draggedTask = toDoItemsArray[indexPath.row]
        let itemProvider = NSItemProvider(object: draggedTask.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = draggedTask
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath,
           let draggedTask = item.dragItem.localObject as? TaskModel {
            collectionView.performBatchUpdates({
                self.toDoItemsArray.remove(at: sourceIndexPath.item)
                self.toDoItemsArray.insert(draggedTask, at: destinationIndexPath.item)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    for i in 0..<self.toDoItemsArray.count{
                        self.toDoItemsArray[i].index = Int64(i)
                    }
                    self.itemsCV.reloadData()
                    CoreDataManager.shared.updateAllTaskIndexes(currentArray: self.toDoItemsArray)
                })
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = AppController.shared.addNewTask
        if let presentationController = nextVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        nextVC.existingData = toDoItemsArray[indexPath.item]
        self.present(nextVC, animated: true)
    }
}
