//
//  REST.swift
//  Carangas
//
//  Copyright © 2020 Ivan Costa. All rights reserved.
//

import Foundation


enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}


enum RESTOperation {
    case save
    case update
    case delete
}
