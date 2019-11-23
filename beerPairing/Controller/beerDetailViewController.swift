//
//  beerDetailViewController.swift
//  beerPairing
//
//  Created by iMac on 23/11/2019.
//  Copyright © 2019 Alfons Gonzalez Tenas. All rights reserved.
//

import UIKit

class beerDetailViewController: UIViewController {

    var beerSelected = Beer()
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailTagLabel: UILabel!
    @IBOutlet weak var detailABVLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTagLabel.text = beerSelected.tagline
        detailNameLabel.text = beerSelected.name
        detailDescriptionLabel.text = beerSelected.beerDescription
        detailABVLabel.text = String(format:"%.1fº", beerSelected.abv)
        if let url = beerSelected.image_url {
            self.detailImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "imageholder"))
        }

    }
    


}
