//
//  Either.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

public enum Either<L, R> {
    case left(L)
    case right(R)
}

public extension Either where L == R {
    
    var value: L {
        switch self {
        case let .left(value):
            return value
        case let .right(value):
            return value
        }
    }
}
