//
//  ListOfCatCell.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import UIKit

// MARK: - ListOfCatCell
/// Custom UITableViewCell used to display a single cat breed in the list with an image, title, and description.
class ListOfCatCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgListItem: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

// MARK: - Cell Setup
extension ListOfCatCell {
    func setUpData(catBreed: CatBreed) {
        viewBG.layer.cornerRadius = 4
        lblTitle.text = catBreed.name
        lblDescription.text = catBreed.description
    }
}
