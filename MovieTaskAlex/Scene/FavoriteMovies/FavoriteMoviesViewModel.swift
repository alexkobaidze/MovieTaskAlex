//
//  FavoriteMoviesViewModel.swift
//  MovieTaskAlex
//
//  Created by Alex on 25.08.22.
//

import CoreData
import Foundation
import UIKit

protocol FavoriteMovieViewModelProtocol: AnyObject {
    
    var showAlert: ((String, String)->())? { get set }
    func startNetworkMonitoring()
    func cleanFavMovies()
    
}

class FavoriteMoviesViewModel: FavoriteMovieViewModelProtocol {
    
    //MARK: - Variables
    
    var showAlert: ((String, String)->())?
    private let reachability = try? Reachability()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - StartMonitoring Network
    
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
    
    //MARK: - Clean Data From Core Data
    
    func cleanFavMovies() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMoviesEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        DispatchQueue.main.async {
            do {
                try context.execute(deleteRequest)
                try context.save()
                
            } catch {
                print ("There was an error")
            }
        }
        
    }

}


