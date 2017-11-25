//
//  RecipesOperation.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import Foundation
import Hydra
import SwiftyJSON

class RecipesOperation<JSON>: Operation {
    
    var parameters: RecipeParameters
    
    init(parameters: RecipeParameters) {
        self.parameters = parameters
    }
    
    var request: Request {
        return RecipeRequests.recipes(parameters: self.parameters)
    }
    
    func execute(in dispatcher: Dispatcher) -> Promise<JSON> {
        return Promise<JSON>({ resolve, reject, _ in
            do {
                try dispatcher.execute(request: self.request).then({ response in
                    switch response {
                    case .json(let responseJSON):
                        resolve(responseJSON as! JSON)
                    case .data(let data):
                        break
                    case .error(let statusCode, let error):
                        reject(error!)
                    }
                    
                }).catch(reject)
            } catch {
                reject(error)
            }
        })
    }
}
