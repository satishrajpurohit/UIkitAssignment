//
//  ViewController.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import UIKit

// MARK: - ViewController
/// The main view controller for displaying a list of cat breeds and images, with a floating button to show statistics.
class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var btnFloatingButton: UIButton!
    @IBOutlet weak var tblCatList: UITableView!
    
    // MARK: - Properties
    private var assignmentListViewModel: AssignmentViewModel?
    var filteredBreeds: [CatBreed] = [CatBreed]()
    private var visibleBreeds: [CatBreed] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Actions
    @IBAction func onClickFloatingButton(_ sender: UIButton) {
        let statisticVC: StatisticViewController = self.storyboard?.instantiateViewController(withIdentifier: "StatisticViewController") as! StatisticViewController
        getVisibleCellData()
        statisticVC.visibleBreeds = self.visibleBreeds
        self.present(statisticVC, animated: true, completion: nil)
    }
    
}

// MARK: - UITableView Delegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        let headerCell = tblCatList.dequeueReusableCell(withIdentifier: "SearchBarCell") as! SearchBarCell
        headerCell.frame = headerView.bounds
        headerCell.delegate = self
        headerView.addSubview(headerCell)
        return section ==  0 ? UIView() : headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : filteredBreeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            guard let catCell = tblCatList.dequeueReusableCell(withIdentifier: "CatPagerTableCell", for: indexPath) as? CatPagerTableCell else { return UITableViewCell() }
            catCell.catImages = assignmentListViewModel?.catImages ?? []
            catCell.reloadGridPager()
            catCell.catPageControl.numberOfPages = assignmentListViewModel?.catImages.count ?? 0
            catCell.gridCatPager.collectionViewLayout.invalidateLayout()
            return catCell
        }
        guard let catCell = tblCatList.dequeueReusableCell(withIdentifier: "ListOfCatCell", for: indexPath) as? ListOfCatCell else { return UITableViewCell() }
        let objCatBreeds = filteredBreeds[indexPath.row]
        catCell.setUpData(catBreed: objCatBreeds)
        return catCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let firstVisibleIndexPath = self.tblCatList.indexPathsForVisibleRows?[0]
            let visibleData = firstVisibleIndexPath?.compactMap { row -> CatBreed? in
                if row < filteredBreeds.count {
                    return filteredBreeds[row]
                } else {
                    return nil
                }
            }
            self.visibleBreeds = visibleData ?? []
        }
    }
    
}

// MARK: - View Configuration
/// Extensions to configure and set up the view controller.
extension ViewController {
    func configureView() {
        assignmentListViewModel = AssignmentViewModel(assignmentListView: self)
        // Set the reachability handler to react to changes in network status
        ReachabilityManager.shared.setReachabilityHandler { isConnected in
            if isConnected {
                self.assignmentListViewModel?.fetchCatImages()
                self.assignmentListViewModel?.fetchCatBreeds()
            }
        }
        btnFloatingButton.layer.cornerRadius = 30
        tblCatList.sectionHeaderTopPadding = 0
    }
    
    func getVisibleCellData() {
        let visibleIndexPath = self.tblCatList.indexPathsForVisibleRows
        let visibleData = visibleIndexPath?.compactMap { indexPath -> CatBreed? in
            if indexPath.row < filteredBreeds.count && indexPath.section == 1 {
                return filteredBreeds[indexPath.row]
            } else {
                return nil
            }
        }
        self.visibleBreeds = visibleData ?? []
    }
}

// MARK: - AssignmentListDelegate
/// Delegate methods to reload data in the view controller after fetching cat breeds and images.
extension ViewController: AssignmentListDelegate {
    func reloadCatImages() {
        tblCatList.reloadData()
    }
    
    func reloadCatBreedList() {
        filteredBreeds = assignmentListViewModel?.catBreeds ?? []
        tblCatList.reloadData()
    }
    
}

// MARK: - SearchDelegate
/// Delegate methods for handling the search functionality.
extension ViewController: SearchDelegate {
    
    func searchQuery(searchValue: String) {
        if searchValue.isEmpty {
            filteredBreeds = assignmentListViewModel?.catBreeds ?? []
        } else {
            filteredBreeds = assignmentListViewModel?.catBreeds.filter { breed in
                breed.name.lowercased().contains(searchValue.lowercased())
            } ?? []
        }
        self.tblCatList.reloadData()
    }
    
}
