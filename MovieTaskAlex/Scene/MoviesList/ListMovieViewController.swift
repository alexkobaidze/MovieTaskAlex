//
//  ListMovieViewController.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import Foundation
import UIKit

protocol ListMovieDisplayLogic: AnyObject {
    func displayMovies(movie: [Movie])
    func displayErrorMessage(error: ErrorResponse)
}

class ListMovieViewController: UITableViewController {
    
    //MARK: - Variables
    
    private var movies: [Movie] = []
    
    private var interactor: ListMovieDataLogic
    
    enum TableViewState {
        case empty
        case loading
        case error
        case populated
    }
    
    var state: TableViewState = .empty {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(interactor: ListMovieDataLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpNavBar()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.fetchMovies()
        interactor.startNetworkMonitoring()
        interactor.showAlert = { [weak self] title, message in
            self?.presentAlert(with: title, message: message)
        }
    }
    //MARK: - Configure UI
    
    func setUpNavBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites".localizedString, style: UIBarButtonItem.Style.done, target: self, action: #selector(done))
        self.title = "Films".localizedString
    }
    
    @objc func done() {
        let detailVC = FavoriteMoviesViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    private func setupView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(ListMovieCell.self, forCellReuseIdentifier: ListMovieCell.cellIdentifier)
        self.tableView.separatorStyle = .none
        
        self.view.backgroundColor = UIColor(named: "BackUIColor")
    }
    private func presentAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Configure Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .populated:
            let cell = tableView.dequeueReusableCell(withIdentifier: ListMovieCell.cellIdentifier, for: indexPath) as! ListMovieCell
            cell.movie = movies[indexPath.row]
            return cell
            
            //MARK: - Cell Sowing States
            
        case .empty:
            return UITableViewCell()
        case .error:
            return UITableViewCell()
        case .loading:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MovieDetailsViewController()
        detailVC.movie = self.movies[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

extension ListMovieViewController: ListMovieDisplayLogic {
    
    func displayMovies(movie: [Movie]) {
        self.movies = movie
        self.state = movie.isEmpty ? .empty : .populated
    }
    
    func displayErrorMessage(error: ErrorResponse) {
        self.state = .error
        print("error message \(error.rawValue)")
        // display error state view here
    }
    
}
