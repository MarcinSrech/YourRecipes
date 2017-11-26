//
//  CDRecipe+CoreDataClass.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//
//

import Foundation
import CoreData
import MagicalRecord

@objc(CDRecipe)
public class CDRecipe: NSManagedObject {

    public override func willImport(_ data: Any)  {
        if let data = data as? [String: Any] {
            CDIngredient.importIngredients(data["ingredients"], context: managedObjectContext!, relationTo: self)
        }
    }
    
    
    func correctFormatImageUrl() -> URL? {
        if let imageURL = self.imageUrl {
            let components = imageURL.components(separatedBy: "\"")
            if let urlString = components.filter({ $0.contains("http") }).first {
                if let url = URL(string: urlString) {
                    return url
                }
            }
        }
        return nil
    }
}
