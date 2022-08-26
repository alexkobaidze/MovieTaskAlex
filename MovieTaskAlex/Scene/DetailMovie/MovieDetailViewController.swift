//
//  MovieDetailViewController.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//

import UIKit
import Kingfisher
import CoreData


class MovieDetailsViewController: UIViewController {
    
    // MARK: - Variables
    
    var movie : Movie?
    private var viewModel: MovieDetailViewModelProtocol = MovieDetailViewModel()
    
    private var id: Int?
    let symbolisFav = UIImage(named: "RemoveStar")
    
    // MARK: - Configure UI
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "NameLabelColor")
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(named: "LabelColor")
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(named: "RatingColor")
        return label
    }()
    
    private let relaseDate: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(named: "LabelColor")
        return label
    }()
    
    private let AddFavoritesButton: UIButton = {
        let button = UIButton()
        button.setTitle("AddFavorites".localizedString, for: .normal)
        let symbol = UIImage(named: "AddStar")
        button.setImage(symbol, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = UIColor(named: "ButtonBack")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 200, height: 60)
        button.layer.cornerRadius = 10
        return button
        
    }()
    
    // MARK: - Lifecycle/Configuration/Setup Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        updateView()
        configureButton()
        viewModel.startNetworkMonitoring()
        configureFav()
        viewModel.showAlert = { [weak self] title, message in
            self?.presentAlert(with: title, message: message)
        }
    }
    
    func configureFav() {
        let isFav = viewModel.someEntityExists(title: movie?.title ?? "")
        if isFav == true {
            configureButtonIsFav()
        } else {
            AddFavoritesButton.isHidden = false
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func configureViews() {
        view.backgroundColor = UIColor(named: "BackUIColor")
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(imgView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(relaseDate)
        scrollView.addSubview(ratingLabel)
        scrollView.addSubview(AddFavoritesButton)
        scrollView.addSubview(overviewLabel)
        
    }
    private func configureButton() {
        AddFavoritesButton.addTarget(
            self,
            action: #selector(createData),
            for: .touchUpInside
        )
    }
    
    private func configureButtonIsFav() {
        AddFavoritesButton.setImage(symbolisFav, for: .normal)
        AddFavoritesButton.backgroundColor = .lightGray
        AddFavoritesButton.setTitle("Added".localizedString, for: .normal)
        AddFavoritesButton.isEnabled = false
    }
    
    
    private func configureConstraints() {
        
        let imageWidth: CGFloat = view.frame.size.width
        let imageHeight: CGFloat = imageWidth
        
        let padding: CGFloat = 12
        let labelSize = view.frame.size.width - 20
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imgView.heightAnchor.constraint(equalToConstant: imageHeight),
            imgView.widthAnchor.constraint(equalToConstant: imageWidth),
            imgView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            
            titleLabel.widthAnchor.constraint(equalToConstant: labelSize),
            titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: padding),
            
            relaseDate.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            relaseDate.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: relaseDate.bottomAnchor, constant: padding),
            ratingLabel.leadingAnchor.constraint(equalTo: relaseDate.leadingAnchor),
            
            AddFavoritesButton.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: padding),
            AddFavoritesButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            
            overviewLabel.widthAnchor.constraint(equalToConstant: labelSize),
            overviewLabel.topAnchor.constraint(equalTo: AddFavoritesButton.bottomAnchor, constant: padding),
            overviewLabel.leadingAnchor.constraint(equalTo: AddFavoritesButton.leadingAnchor),
            overviewLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding)
            
        ])
    }
    
    // MARK: - Data Manipulation
    
    private func updateView() {
        
        let imageURL = movie?.posterURL
        imgView.kf.setImage(with: imageURL)
        overviewLabel.text =  movie?.overview
        ratingLabel.text = "IBMD Rating".localizedString + "  \(movie?.voteAverage ?? 0)"
        let filmDate = "ReleaseDate".localizedString + "  \(movie?.releaseDate! ?? Date())".dropLast(9)
        relaseDate.text = filmDate
        titleLabel.text = movie?.title
        id = movie?.id
        print("aidiiii\(id ?? 0)")
    }
    private func presentAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc  func createData (){
        viewModel.addToFav(title: titleLabel.text ?? "", overView: overviewLabel.text ?? "", moviePoster: (imgView.image?.pngData())!)
        configureFav()
    }
    
    
}
