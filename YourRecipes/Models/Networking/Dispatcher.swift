//
//  Dispatcher.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import Foundation
import Hydra

protocol Dispatcher {
    
    init(environment: Environment)
    
    func execute(request: Request) throws -> Promise<Response>
}
