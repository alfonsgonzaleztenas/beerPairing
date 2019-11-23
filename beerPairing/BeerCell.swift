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
    
    func setBeerCellWith(beer: Beer) {
        
        DispatchQueue.main.async {
            
            self.beerNameLabel.text = beer.name
            self.beerTalLabel.text = beer.tagline
            self.beerABVLabel.text = String(format:"%.1fº", beer.abv)
            if let url = beer.image_url {
                self.beerImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "imageholder"))
            }
 

        }
    }
    
    
}


