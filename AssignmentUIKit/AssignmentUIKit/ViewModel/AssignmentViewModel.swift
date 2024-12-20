//
//  AssignmentViewModel.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import Foundation

// MARK: - AssignmentListDelegate
/// A protocol that defines methods for reloading cat images and cat breed list.
/// This protocol is intended to be implemented by any class that wants to handle the reloading of data.
protocol AssignmentListDelegate: AnyObject {
    func reloadCatImages()
    func reloadCatBreedList()
}

// MARK: - AssignmentViewModel
/// The view model for managing and fetching cat-related data such as images and breeds.
class AssignmentViewModel {
    private let networkManager = NetworkManager()
    private let dataDecoder = DataDecoder()
    
    var catImages: [CatImage] = []
    var catBreeds: [CatBreed] = []
    weak var delegate: AssignmentListDelegate?
    
    init(assignmentListView: ViewController) {
        self.delegate = assignmentListView
    }
    
    // MARK: - Fetch Cat Images
    /// Fetches cat images from the API and updates the `catImages` property
    func fetchCatImages() {
        guard let url = URL(string: APIConstants.catImagesURL) else { return }
        networkManager.fetchData(from: url) { [weak self] data in
            if let data = data {
                if let decodedImages: [CatImage] = self?.dataDecoder.decode(data, to: [CatImage].self) {
                    DispatchQueue.main.async {
                        self?.catImages = decodedImages
                        self?.delegate?.reloadCatImages()
                    }
                }
            }
        }
    }
    
    // MARK: - Fetch Cat Breeds
    /// Fetches cat breeds from the API and updates the `catBreeds` property
    func fetchCatBreeds() {
        guard let url = URL(string: APIConstants.catBreedsURL) else { return }
        networkManager.fetchData(from: url) { [weak self] data in
            if let data = data {
                if let decodedImages: [CatBreed] = self?.dataDecoder.decode(data, to: [CatBreed].self) {
                    DispatchQueue.main.async {
                        self?.catBreeds = decodedImages
                        self?.delegate?.reloadCatBreedList()
                    }
                }
            }
        }
    }
}
