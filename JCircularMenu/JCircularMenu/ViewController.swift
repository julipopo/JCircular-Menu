//
//  ViewController.swift
//  CircularMenu
//
//  Created by Julien Simmer  on 19/03/2017.
//  Copyright © 2017 Julien Simmer . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var circularMenu =  JCircularMenu()
    
    @IBOutlet var centerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circularMenu = JCircularMenu(inView: view, withColor: UIColor(red: 41/255, green: 128/255, blue : 185/255, alpha: 1.0))
        
        circularMenu.delegate = self
        
        circularMenu.addButton(title: "Heel", imageName: "icon_heel")
        circularMenu.addButton(title: "Truck", imageName: "icon_truck")
        circularMenu.addButton(title: "Spider", imageName: "icon_spider")
        circularMenu.addButton(title: "Brique", imageName: "icon_brique")
        circularMenu.addButton(title: "Cardio", imageName: "icon_cardio")
        circularMenu.addButton(title: "Path", imageName: "icon_path")
        circularMenu.addButton(title: "Medecin", imageName: "icon_medecin")
        circularMenu.addButton(title: "Camembert", imageName: "icon_camembert")
        
        view.addSubview(circularMenu)
    }
    
}

extension ViewController: JCircularMenuDelegate {
    
    func jcircularMenuDidSelect(atIndex index: Int) {
        
        if let label = circularMenu.buttons[index].subviews[1] as? UILabel {
            centerLabel.text = label.text
        }
    }
    
    func jcircularMenuDidOpen() {
        print("OPEN")
    }
    
}
