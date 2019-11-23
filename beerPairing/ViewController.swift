//
//  ViewController.swift
//  beerPairing
//
//  Created by iMac on 23/11/2019.
//  Copyright © 2019 Alfons Gonzalez Tenas. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var viewModel : MainViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var beerSearchBar: UISearchBar!
    
    var beersArray = [Beer]()
    let manager = CoreDataManager()
    let service = APIService()
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func saveInCoreDataWith(array: [[String: Any]]) {
        _ = array.map{manager.createBeerEntityFrom(dictionary: $0 as [String : AnyObject])}
        manager.saveContext()
        beersArray = manager.fetchBeers()
        tableView.reloadData()
     }
     

    private func searchFood (foodToSearch : String){
        
        beersArray = manager.fetchBeersWithFood(foodToSearch: foodToSearch)
        
        if beersArray.count > 0  {
            tableView.reloadData()
        } else{
            service.getDataWith(food: foodToSearch) { (result) in
                 switch result {
                 case .Success(let data):
                     self.saveInCoreDataWith(array: data)
                 case .Error(let message):
                     DispatchQueue.main.async {
                         self.showAlertWith(title: "Error", message: message)
                     }
                 }
             }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "beerDetail" {
            let destinationVC = segue.destination as! beerDetailViewController
            if let selectedRow = tableView.indexPathForSelectedRow?.row {
                destinationVC.beerSelected = beersArray[selectedRow]
            }
        }
         
    }
    
    
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchFood(foodToSearch: searchBar.text!)
        searchBar.resignFirstResponder()
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beercell", for: indexPath) as! BeerCell
        cell.setBeerCellWith(beer: beersArray[indexPath.row])
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120//UITableView.automaticDimension
    }
}
