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
    
    /// Ordenem la llista de cerveses a la inversa de l'ordre actual
    /// - Retornem el text del botó
    func sort() -> String {
        ascending = !ascending
        beersArray = getSortedArray(beers: beersArray)
        return ascending ? "Stronger First" : "Lighter first"
    }
    
    /// Ordenem l'array segons ABV, asc o desc
    /// - Parameter beers: Array que volem ordenar
    func getSortedArray (beers : [Beer]) -> [Beer] {
        return ascending ? beers.sorted(by: { $0.abv < $1.abv }) : beers.sorted(by: { $0.abv > $1.abv })
    }
    
    /// Busquem el menjar
    /**
            - Si l'hem consultat abans, mostrem la informació de la BD
            - Si no l'hem buscat abans, consultem la API
     */
    func searchFood (foodToSearch : String, completion: @escaping (ResultSearch) -> Void) {
        beersArray.removeAll()
        if manager.fetchSearchFood(foodToSearch: foodToSearch){
            beersArray = getSortedArray(beers: manager.fetchBeersWithFood(foodToSearch: foodToSearch))
            return completion(.SuccessVoid)
        }else{
            service.getDataWith(food: foodToSearch) { (result) in
                 switch result {
                 case .Success(let data):
                    let beers = data.map{self.manager.createBeerEntityFrom(dictionary: $0 as [String : AnyObject])}
                    self.manager.insertSearch(food: foodToSearch)
                    self.manager.saveContext()
                    beersArray =  self.getSortedArray(beers: beers as! [Beer])
                    return completion(.SuccessVoid)
                    
                 case .Error(let message):
                    return completion(.Error(message))
                 }
             }
        }

    }
}
