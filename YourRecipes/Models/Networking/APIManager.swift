//
//  APIManager.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import Foundation
import Hydra
import SwiftyJSON
import MagicalRecord

class APIManager {
    //MARK: - Properties
    let environment: Environment
    let dispatcher: NetworkDispatcher
    
    
    //MARK: - Singleton
    static let shared = APIManager()
    private init() {
        let headers = ["Content-Type": "application/json"]
        environment = Environment(name: "Prod", host: "http://www.godt.no/api", headers: headers, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        dispatcher = NetworkDispatcher(environment: environment)
    }
    
    
    //MARK: - Recipes
    func fetchRecipes(parameters: RecipeParameters) -> Promise<Void> {
        let recipesOperation = RecipesOperation<JSON>(parameters: parameters)
        return Promise<Void>({ [unowned self] (resolve, reject, _) in
            recipesOperation.execute(in: self.dispatcher).then({ (responseJSON) in
                guard let array = responseJSON.rawValue as? [[AnyHashable: Any]] else {
                    return resolve(Void())
                }
                
                let context = NSManagedObjectContext.mr_()
                CDRecipe.mr_truncateAll(in: context)
                CDIngredient.mr_truncateAll(in: context)
                _ = CDRecipe.mr_import(from: array, in: context)
                context.mr_saveToPersistentStoreAndWait()
                resolve(Void())
            }).catch({ (error) in
                reject(error)
            })
        })
    }
}
