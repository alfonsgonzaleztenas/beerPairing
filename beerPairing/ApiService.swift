//
//  ApiService.swift
//  beerPairing
//
//  Created by iMac on 23/11/2019.
//  Copyright © 2019 Alfons Gonzalez Tenas. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Error(String)
}

class APIService: NSObject {
    
    ///Direcció de la API
    let urlApi = "https://api.punkapi.com/v2/beers"
   
    /**
        Funcio que busca les cerveses que fan maridatge amb el menjar seleccionat i ens parseja el JSON
     - Parameter food: Menjar que volem trobar la relació
     - Parameter completion : Resultat de la consulta
            - Retornem un String en cas d'error
            - Retornem l'array de valors en cas d'èxit
    */
    func getDataWith(food : String, completion: @escaping (Result<[[String: Any]]>) -> Void) {
        
        let urlString = food == "" ? urlApi : urlApi + "?food=\(food)&per_page=80"
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update")) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "Error getData"))}
            
             do{
                if let itemsJsonArray = try JSONSerialization.jsonObject(with:data, options: []) as? [[String: Any]] {
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
                
              } catch let parsingError {
                 print("Error", parsingError)
                return completion(.Error(error?.localizedDescription ?? "Error getData"))
            }

        }.resume()
    }
}


