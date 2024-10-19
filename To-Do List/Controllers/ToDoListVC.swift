//
//  ToDoListVC.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

class ToDoListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

    // MARK: - FUNCTIONS
    func configView(){
        ItemCVC.register(for: itemsCV)
        itemsCV.delegate = self
        itemsCV.dataSource = self
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
        return CGSize(width: itemsCV.frame.width, height:  200)
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
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}
