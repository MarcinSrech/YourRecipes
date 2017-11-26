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
    
    
    class public func importIngredients(_ data: Any, context: NSManagedObjectContext, relationTo: CDRecipe?) {
        let dictionary = data as? [[String: Any]]
        for box in dictionary! {
            if let ingredients = box["elements"] as? [[String: Any]] {
                for ingredient in ingredients {
                    var cdIngredient = CDIngredient.mr_findFirst(byAttribute: "externalId", withValue: ingredient["id"]!, in: context)
                    if cdIngredient == nil {
                        cdIngredient = CDIngredient.mr_createEntity(in: context)
                        relationTo?.addToIngredients(cdIngredient!)
                        if !(ingredient["id"] is NSNull) {
                            cdIngredient?.externalId =  (ingredient["id"] as! NSNumber).int32Value
                        }
                    }
                    
                    if !(ingredient["amount"] is NSNull) {
                        cdIngredient?.amount =  (ingredient["amount"] as! NSNumber).int32Value
                    }
                    cdIngredient?.name = ingredient["name"] as? String
                    cdIngredient?.symbol = ingredient["symbol"] as? String
                }
            }
        }
    }
    
    

}
