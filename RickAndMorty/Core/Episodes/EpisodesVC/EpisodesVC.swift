//
//  EpisodesVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 16.11.23.
//

import UIKit

final class EpisodesVC: UIViewController {
    
    private var hasMoreEpisodes = true
    private var isLoadingEpisodes = false
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
        isLoadingEpisodes = true
        URLSession.shared.decode(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response): self.handleSuccessResponse(with: response)
            case .failure(let error): self.handleFailureResult(with: error)
            }
            self.isLoadingEpisodes = false
        }
    }
    
    private func handleSuccessResponse(with response: RMEpisodeResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if response.results.count < 20 { hasMoreEpisodes = false }
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
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if scrollY > contentHeight - screenHeight {
            guard hasMoreEpisodes, !isLoadingEpisodes else { return }
            page += 1
            getAllEpisodes(page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        let destinationVC = EpisodeDetailVC(episode: episode)
        
        if let name = episode.name {
            destinationVC.title = name
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
