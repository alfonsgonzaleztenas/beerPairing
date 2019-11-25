//
//  BeerCell.swift
//  beerPairing
//
//  Created by iMac on 23/11/2019.
//  Copyright © 2019 Alfons Gonzalez Tenas. All rights reserved.
//

import Foundation
import UIKit

class BeerCell : UITableViewCell {
    
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerABVLabel: UILabel!
    @IBOutlet weak var beerTalLabel: UILabel!
    
    /**
    - Establim els valors visuals de la cela
    - Parameter beer: Objecte Beer que mostrarem
     */
    func setBeerCellWith(beer: Beer) {
        
        DispatchQueue.main.async {
            
            self.beerNameLabel.text = beer.name
            self.beerTalLabel.text = beer.tagline
            self.beerABVLabel.text = String(format:"%.1f%", beer.abv)
            self.beerABVLabel.layer.masksToBounds = true
            self.beerABVLabel.layer.cornerRadius = self.beerABVLabel.frame.width / 2
            if let url = beer.image_url {
                self.beerImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "imageholder"))
            }
 

        }
    }
    
    
}


