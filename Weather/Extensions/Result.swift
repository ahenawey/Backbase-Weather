//
//  Result.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright © 2018 Ahmed Ali Henawey. All rights reserved.
//

import Foundation

enum Result<T,E: Swift.Error> {
    case success(T)
    case failure(E)
}
