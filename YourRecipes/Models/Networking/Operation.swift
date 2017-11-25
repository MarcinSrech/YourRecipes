//
//  Operation.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import Foundation
import Hydra

protocol Operation {
    associatedtype Output
    
    var request: Request {get}
    
    func execute(in dispatcher: Dispatcher) -> Promise<Output>
}

