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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(beerSelected.beerDescription)
    }
    


}
