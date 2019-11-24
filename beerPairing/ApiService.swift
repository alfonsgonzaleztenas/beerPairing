//
//  ApiService.swift
//  beerPairing
//
//  Created by iMac on 23/11/2019.
//  Copyright © 2019 Alfons Gonzalez Tenas. All rights reserved.
//

import Foundation

class APIService: NSObject {
    
    let urlApi = "https://api.punkapi.com/v2/beers"
    
    
    let query = ""
    lazy var endPoint: String = {
        return "https://api.punkapi.com/v2/beers\(self.query)"
    }()
 
    /*
    let query = "dogs"
    lazy var endPoint: String = {
        return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(self.query)&nojsoncallback=1#"
    }()

*/
    
    func getDataWith(food : String, completion: @escaping (Result<[[String: Any]]>) -> Void) {
        
        let urlString = food == "" ? urlApi : urlApi + "?food=\(food)&per_page=80"
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))}
            
             do{
                 //here dataResponse received from a network request
                if let itemsJsonArray = try JSONSerialization.jsonObject(with:data, options: []) as? [[String: Any]] {
                    //print(itemsJsonArray) //Response result
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
                
              } catch let parsingError {
                 print("Error", parsingError)
                return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }

        }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}
