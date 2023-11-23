//
//  LocationsVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 15.11.23.
//

import SwiftUI
import UIKit

final class LocationsVC: UIViewController {
    
    private var page = 1
    private var locations: [RMLocation] = []
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureTableView()
        getAllCharacters(page: page)
    }
    
    private func getAllCharacters(page: Int) {
        let request: Request<RMLocationResponse> = .getAllLocations(forPage: page)
        URLSession.shared.decode(request) { result in
            switch result {
            case .success(let response): self.handleSuccessResponse(with: response)
            case .failure(let error): self.handleFailureResult(with: error)
            }
        }
    }
    
    private func handleSuccessResponse(with response: RMLocationResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.locations = response.results
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
    
    private func handleFailureResult(with error: APIError) {
        print("Error:", error)
        // MARK: Show Alert OR Empty State view.
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 100
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseId)
    }
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: TableView Data Source methods
extension LocationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseId) as! LocationCell
        let location = locations[indexPath.row]
        cell.set(location: location)
        return cell
    }
}

extension LocationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = LocationDetailVC()
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
