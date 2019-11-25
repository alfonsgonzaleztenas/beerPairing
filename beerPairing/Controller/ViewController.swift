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

    var viewModel : MainViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var beerSearchBar: UISearchBar!
           
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewModel()
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beerDetail" {
            let destinationVC = segue.destination as! beerDetailViewController
            if let selectedRow = tableView.indexPathForSelectedRow?.row {
                destinationVC.beerSelected = beersArray[selectedRow]
            }
        }
    }

    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
        beerSearchBar.resignFirstResponder()
        sender.title = viewModel.sort()
        if beersArray.count > 0 {
            self.tableView.setContentOffset(.zero, animated: false)
            self.tableView.reloadData()
        }
    }
    
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchFood(foodToSearch: searchBar.text!) { (result) in
            switch result {
                case .SuccessVoid:
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(.zero, animated: false)
                case .Error(let message):
                    DispatchQueue.main.async {
                        self.showAlertWith(title: "Error", message: message)
                    }
            }
        }
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

