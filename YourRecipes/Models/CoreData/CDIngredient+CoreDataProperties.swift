//
//  CDIngredient+CoreDataProperties.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//
//

import Foundation
import CoreData


extension CDIngredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDIngredient> {
        return NSFetchRequest<CDIngredient>(entityName: "CDIngredient")
    }

    @NSManaged public var externalId: Int32
    @NSManaged public var amount: Int32
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var recipe: CDRecipe?

}
