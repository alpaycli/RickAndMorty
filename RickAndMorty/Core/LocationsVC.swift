//
//  LocationsVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 15.11.23.
//

import UIKit

final class LocationsVC: UIViewController {
    
    private var page = 1
    private var locations: [RMLocation] = []
    
    private let tableView = UITableView()
    
    private let manager: NetworkManager
    
    init(manager: NetworkManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureTableView()
        getAllCharacters(page: page)
    }
    
    func getAllCharacters(page: Int) {
        guard let url = URL(string: manager.baseURL + "location/?page=\(page)") else { return }
        let request = URLRequest(url: url)
        
        manager.fetch(RMLocationResponse.self, urlRequest: request) { result in
            
            switch result {
            case .success(let response):
                print(response.results.count)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.locations = response.results
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
            case .failure(let error):
                print("Error:", error)
                // MARK: Show Alert OR Empty State view.
            }
        }
    }

    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 100
        
        tableView.dataSource = self
//        tableView.delegate = self
        
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
        let location = locations[indexPath.item]
        cell.set(location: location)
        return cell
    }
    
    
}
