//
//  mainViewModel.swift
//  beerPairing
//
//  Created by iMac on 23/11/2019.
//  Copyright © 2019 Alfons Gonzalez Tenas. All rights reserved.
//

import Foundation

var beersArray = [Beer]()

enum ResultSearch {
    case SuccessVoid
    case Error(String)
}

class MainViewModel {
    
    let manager = CoreDataManager()
    let service = APIService()
    var ascending = true
    
    func sort() -> String {
        beersArray = ascending ? beersArray.sorted(by: { $0.abv > $1.abv }) : beersArray.sorted(by: { $0.abv < $1.abv })
        ascending = !ascending
        return ascending ? "Stronger First" : "Lighter first"
    }
    
    func searchFood (foodToSearch : String, completion: @escaping (ResultSearch) -> Void) {
        
        beersArray = manager.fetchBeersWithFood(foodToSearch: foodToSearch)
        
        if beersArray.count > 0  {
            return completion(.SuccessVoid)
        } else{
            service.getDataWith(food: foodToSearch) { (result) in
                 switch result {
                 case .Success(let data):
                    //self.saveInCoreDataWith(array: data)
                    _ = data.map{self.manager.createBeerEntityFrom(dictionary: $0 as [String : AnyObject])}
                    self.manager.saveContext()
                    beersArray = self.manager.fetchBeers()
                    return completion(.SuccessVoid)
                    
                 case .Error(let message):
                    return completion(.Error(message))
                 }
             }
        }

    }
}
