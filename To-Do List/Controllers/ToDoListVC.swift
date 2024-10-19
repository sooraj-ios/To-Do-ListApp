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
    var toDoItemsArray:[TaskModel] = [
        TaskModel(index: 0, title: "Title 1", desc: "desc 1", dueDate: "Due Date 1", priority: "priority 1"),
        TaskModel(index: 1, title: "Title 2", desc: "desc 2", dueDate: "Due Date 2", priority: "priority 2"),
        TaskModel(index: 2, title: "Title 3", desc: "desc 3", dueDate: "Due Date 3", priority: "priority 3"),
        TaskModel(index: 3, title: "Title 4", desc: "desc 4", dueDate: "Due Date 4", priority: "priority 4"),
        TaskModel(index: 4, title: "Title 5", desc: "desc 5", dueDate: "Due Date 5", priority: "priority 5")
    ]

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }

    // MARK: - FUNCTIONS
    func configView(){
        ItemCVC.register(for: itemsCV)
        itemsCV.delegate = self
        itemsCV.dataSource = self
        itemsCV.dragDelegate = self
        itemsCV.dropDelegate = self
        itemsCV.dragInteractionEnabled = true
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
}
