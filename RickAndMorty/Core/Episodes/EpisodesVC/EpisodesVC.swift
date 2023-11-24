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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureTableView()
        getAllEpisodes(page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getAllEpisodes(page: Int) {
        let request: Request<RMEpisodeResponse> = .getAllEpisodes(forPage: page)
        URLSession.shared.decode(request) { result in
            switch result {
            case .success(let response): self.handleSuccessResponse(with: response)
            case .failure(let error): self.handleFailureResult(with: error)
            }
        }
    }
    
    private func handleSuccessResponse(with response: RMEpisodeResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.episodes = response.results
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
        tableView.rowHeight = 120
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseId)
    }

    private func setupViewController() {
        view.backgroundColor = .systemBackground
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

extension EpisodesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        let destinationVC = EpisodeDetailVC(episode: episode)
        
        if let name = episode.name {
            destinationVC.title = name
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
