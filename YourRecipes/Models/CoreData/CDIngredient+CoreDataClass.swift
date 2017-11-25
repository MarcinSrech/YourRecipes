//
//  CDIngredient+CoreDataClass.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//
//

import Foundation
import CoreData
import MagicalRecord

@objc(CDIngredient)
public class CDIngredient: NSManagedObject {

 
    
    public override func willImport(_ data: Any) {
        let dictionary = data as? [String: Any]
        if let ingredients = dictionary?["elements"] as? [[String: Any]] {
            for ingredient in ingredients {
                var cdIngredient = CDIngredient.mr_findFirst(byAttribute: "externalId", withValue: ingredient["id"]!, in: managedObjectContext!)
                if cdIngredient == nil {
                    cdIngredient = CDIngredient.mr_createEntity(in: managedObjectContext!)
                }
                
                if !(ingredient["amount"] is NSNull) {
                    cdIngredient?.amount =  (ingredient["amount"] as! NSNumber).int32Value
                }
                cdIngredient?.name = ingredient["name"] as? String
                cdIngredient?.symbol = ingredient["symbol"] as? String
            }
        }
        managedObjectContext?.mr_saveOnlySelfAndWait()
    }

}
