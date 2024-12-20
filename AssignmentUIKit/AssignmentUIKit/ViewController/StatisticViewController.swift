//
//  StatisticViewController.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import UIKit

// MARK: - StatisticViewController
/// The view controller responsible for displaying statistics related to the visible cat breeds,
/// such as the total number of visible items and the top 3 most frequent characters in breed names.
class StatisticViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTotalCount: UILabel!
    @IBOutlet weak var lblFirstCharacter: UILabel!
    @IBOutlet weak var lblSecondCharacter: UILabel!
    @IBOutlet weak var lblThirdCharacter: UILabel!
    
    // MARK: - Properties
    private var statisticViewModel: StatisticViewModel?
    var visibleBreeds: [CatBreed] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

// MARK: - Configure View
/// Extension to `StatisticViewController` to configure the view with statistics.
extension StatisticViewController {
    
    /// Configures the UI with the total visible items and the top 3 frequent characters.
    func configureView() {
        statisticViewModel = StatisticViewModel()
        let topThreeFrequentCharacters = statisticViewModel?.getTop3FrequentCharacters(visibleBreeds: visibleBreeds)
        self.lblTotalCount.text = "Total Visible Items: \(visibleBreeds.count)"
        
        self.lblFirstCharacter.text = "\(String(describing: topThreeFrequentCharacters![0].0)): \(String(describing: topThreeFrequentCharacters![0].1))"
        self.lblSecondCharacter.text = "\(String(describing: topThreeFrequentCharacters![1].0)): \(String(describing: topThreeFrequentCharacters![1].1))"
        self.lblThirdCharacter.text = "\(String(describing: topThreeFrequentCharacters![2].0)): \(String(describing: topThreeFrequentCharacters![2].1))"
    }
    
}
