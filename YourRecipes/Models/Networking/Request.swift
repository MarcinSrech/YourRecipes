//
//  Request.swift
//  YourRecipes
//
//  Created by user908549 on 11/25/17.
//  Copyright © 2017 Marcin Srech. All rights reserved.
//

import Foundation

enum DataType {
    case JSON
    case DATA
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

enum RequestParams {
    case url(_: [String: Any]?)
    case body(_: [String: Any]?)
}

protocol Request {
    var path: String {get}
    var method: HTTPMethod {get}
    var parameters: RequestParams {get}
    var headers: [String: Any]? {get}
    var dataType: DataType {get}
}
