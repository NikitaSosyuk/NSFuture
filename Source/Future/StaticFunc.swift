//
//  StaticFunc.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

public func all<T, U>(_ f1: NSFuture<T>, _ f2: NSFuture<U>) -> NSFuture<(T, U)> {
    let (future, callback) = NSFuture<(T, U)>.create()
    f1.resolved { p1 in
        f2.resolved { p2 in
            callback((p1, p2))
        }
    }
    return future
}

public func all<T, U, V>(_ f1: NSFuture<T>, _ f2: NSFuture<U>, _ f3: NSFuture<V>) -> NSFuture<(T, U, V)> {
    let (future, callback) = NSFuture<(T, U, V)>.create()
    f1.resolved { p1 in
        f2.resolved { p2 in
            f3.resolved { p3 in
                callback((p1, p2, p3))
            }
        }
    }
    return future
}

public func first<T, U>(_ a: NSFuture<T>, _ b: NSFuture<U>) -> NSFuture<Either<T, U>> {
    let (future, callback) = NSFuture<Either<T, U>>.create()
    var resolved = false

    func fullfil(_ value: Either<T, U>) {
        if !resolved {
            resolved = true
            callback(value)
        }
    }

    a.resolved { fullfil(.left($0)) }
    b.resolved { fullfil(.right($0)) }

    return future
}

@inlinable public func all<T>(futures: [NSFuture<T>]) -> NSFutureArray<T> {
    guard let future = futures.first else {  return NSFutureArray(callback: []) }

    guard futures.count > 1 else {
        return future.map { [$0] }
    }

    let lastFutures = Array(futures.dropFirst())
    return all(
        future,
        all(futures: lastFutures)
    ).flatMap {
        NSFuture(callback: [$0.0] + $0.1)
    }
}
