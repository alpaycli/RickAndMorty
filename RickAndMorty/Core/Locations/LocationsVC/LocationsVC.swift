//
//  LocationsVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 15.11.23.
//

import SwiftUI
import UIKit

final class LocationsVC: UIViewController {
    
    private var hasMoreLocations = true
    private var isLoadingLocations = false
    private var page = 1
    private var locations: [RMLocation] = []
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureTableView()
        getAllLocations(page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getAllLocations(page: Int) {
        let request: Request<RMLocationResponse> = .getAllLocations(forPage: page)
        isLoadingLocations = true
        URLSession.shared.decode(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response): self.handleSuccessResponse(with: response)
            case .failure(let error): self.handleFailureResult(with: error)
            }
            self.isLoadingLocations = false
        }
    }
    
    private func handleSuccessResponse(with response: RMLocationResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if response.results.count < 20 { hasMoreLocations = false }
            self.locations.append(contentsOf: response.results)
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
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if scrollY > contentHeight - screenHeight {
            guard hasMoreLocations, !isLoadingLocations else { return }
            page += 1
            getAllLocations(page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        let destVC = LocationDetailVC(location: location)
        destVC.title = location.name ?? ""
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
