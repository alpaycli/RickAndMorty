//
//  EpisodesVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 16.11.23.
//

import UIKit

final class EpisodesVC: UIViewController {
    
    private var page = 1
    private var episodes: [RMEpisode] = []
    
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
        guard let url = URL(string: manager.baseURL + "episode/?page=\(page)") else { return }
        let request = URLRequest(url: url)
        
        manager.fetch(RMEpisodeResponse.self, urlRequest: request) { result in
            
            switch result {
            case .success(let response):
                print(response.results.count)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.episodes = response.results
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
        tableView.rowHeight = 120
        
        tableView.dataSource = self
//        tableView.delegate = self
        
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseId)
    }

    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: TableView Data Source methods
extension EpisodesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseId) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.set(episode: episode)
        return cell
    }
    
    
}
