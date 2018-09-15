//
//  cardView.swift
//  Qurba Task
//
//  Created by Admin on 8/31/18.
//  Copyright © 2018 Admin. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class cardView: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    var names :[String] = []
   
    override func viewDidLoad() {
         super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let testArray : [String] = UserDefaults.standard.object(forKey: "names") as! [String]
        return testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! CollectionViewCell
        
        // set name label in the cell from names array
        let namesArray : [String] = UserDefaults.standard.object(forKey: "names") as! [String]
        cell.locname.text = namesArray[indexPath.row] as String
        
        // set  the image in the cell from images array
        let imagesArray : [String] = UserDefaults.standard.object(forKey: "pics") as! [String]
        if let data = NSData(contentsOf: NSURL(string:imagesArray[indexPath.row] as String )! as URL) {
                cell.image.image = UIImage(data: data as Data)
            }
        // set category label in the cell from categories array
        let categoriesArray : [String] = UserDefaults.standard.object(forKey: "cats") as! [String]
            cell.desc.text = categoriesArray[indexPath.row] as String
    
        let rate: UIImage = UIImage(named: "Vector_Smart_Object-2")!
        cell.rate.image = rate
        
        let loc: UIImage = UIImage(named: "Path_1009-1")!
        cell.location.image = loc
        
        // set location label in the cell from locations array
        let addressessArray : [String] = UserDefaults.standard.object(forKey: "loc") as! [String]
        cell.locTxt.text = addressessArray[indexPath.row] as String
        
        // set the shadows
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 0.2
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
       
        return cell
        
    }
    
  
    
}
