//
//  MovieDetailViewModel.swift
//  MovieTaskAlex
//
//  Created by Alex on 24.08.22.
//
import CoreData
import Foundation
import UIKit

protocol MovieDetailViewModelProtocol {
    
    var showAlert: ((String, String)->())? { get set }
    func startNetworkMonitoring()
    func getdetailMovie(movie: Movie)
    func someEntityExists(title: String) -> Bool
    func addToFav(title: String, overView: String, moviePoster: Data )
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    // MARK: - Variables
    
    private let reachability = try? Reachability()
    private var favMovies: [FavMoviesEntity]?
    var movie: Movie?
    var showAlert: ((String, String)->())?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Details Manipulation
    
    func getdetailMovie(movie: Movie) {
        self.movie = movie
    }
    
    func startNetworkMonitoring() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.reachability?.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            self.reachability?.whenUnreachable = { _ in
                print("Not reachable")
                self.showAlert?("Oops...", "Something went wrong with your connection, Please try to connect internet again.")
            }
            
            do {
                try self.reachability?.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    // MARK: - Check Core data file exist
    
    func someEntityExists(title: String) -> Bool {
        let entityForTableName = NSEntityDescription.entity(forEntityName: "FavMoviesEntity", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        var isFav: Bool?
        // Predicate with value which are you wan't to be repeated i.e server_id, item_id etc.
        let predicate = NSPredicate.init(format: "title == %@", title)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityForTableName
        
        do {
            let arrData = try context.fetch(fetchRequest)
            
            if arrData.count > 0 {
                isFav = true
            } else {
                isFav = false
            }
            
        } catch {
            print(error.localizedDescription)
        }
        return isFav ?? false
    }
    
    // MARK: - Add data In core data
    
    func addToFav(title: String, overView: String , moviePoster: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "FavMoviesEntity", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(title, forKeyPath: "title")
        user.setValue(overView,forKey:"overview")
        user.setValue(moviePoster,forKey:"posterImage")
        
        do {
            try managedContext.save()
            print("saved")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

