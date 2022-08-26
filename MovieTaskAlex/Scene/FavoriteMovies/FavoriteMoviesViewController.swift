//
//  FavoriteMoviesViewController.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import UIKit
import CoreData


class FavoriteMoviesViewController: UITableViewController {
    
    //MARK: - Variables
    
    private var favMovies: [FavMoviesEntity]?
    private let viewModel: FavoriteMovieViewModelProtocol = FavoriteMoviesViewModel()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var noDatalabel: UILabel {
        let label = UILabel(frame: tableView.bounds)
        label.text = "you Dont Have favorite Films"
        label.textColor = .black
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFavMovies()
        setupView()
        setUpNavBar()
    }
    
    //MARK: - SetUp UI
    
    private func setupView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(ListMovieCell.self, forCellReuseIdentifier: ListMovieCell.cellIdentifier)
        self.tableView.separatorStyle = .none
        
        self.view.backgroundColor = UIColor(named: "BackUIColor")
        
        if favMovies?.count ?? 0 == 0 {
            presentAlert(with: "Attention".localizedString, message: "you Dont Have favorite Films".localizedString)
        }
    }
    
    private func setUpNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CleanFavorites".localizedString, style: UIBarButtonItem.Style.done, target: self, action: #selector(Clean))
        self.title = "Favorites".localizedString
    }
    
    //MARK: - Configure TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMovies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favMovies = self.favMovies?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ListMovieCell.cellIdentifier, for: indexPath) as! ListMovieCell
        let posterImage = favMovies?.posterImage
        cell.titleLabel.text = favMovies?.title
        cell.overviewLabel.text = favMovies?.overview
        cell.movieImageView.image = UIImage(data: posterImage ?? Data())
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    //MARK: - Functions
    
    @objc func Clean() {
        
        let refreshAlert = UIAlertController(title:"Attention".localizedString, message: "You Want To Clean Favorites".localizedString, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes".localizedString, style: .default, handler: { (action: UIAlertAction!) in
            self.viewModel.cleanFavMovies()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.navigationController?.popViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No".localizedString, style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    func fetchFavMovies() {
        do{
            self.favMovies =   try  context.fetch(FavMoviesEntity.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
        }
    }
    private func presentAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localizedString, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

