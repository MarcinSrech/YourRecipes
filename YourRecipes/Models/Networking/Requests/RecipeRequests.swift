//
//  RecipeRequests.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import Foundation


enum RecipeRequests: Request {
    case recipes(parameters: RecipeParameters)
    
    var path: String {
        switch self {
        case .recipes:
            return "getRecipesListDetailed"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .recipes(_):
            return .GET
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .recipes(let parameters):
            let urlParameters = ["tags": parameters.tags,
                                 "size": parameters.size,
                                 "ratio": "\(parameters.ratio)",
                                 "limit": "\(parameters.limit)",
                                 "from": "\(parameters.from)" ]
            return .url(urlParameters)
        }
    }
    
    var headers: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var dataType: DataType
    {
        switch self {
        case .recipes:
            return .JSON
        }
    }

}
