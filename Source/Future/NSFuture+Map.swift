//
//  NSFuture+Higher-order.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

extension NSFuture {

    public func map<U>(_ transform: @escaping (T) -> U) -> NSFuture<U> {
        let (future, callback) = NSFuture<U>.create()
        self.resolved { action in
            callback(transform(action))
        }
        return future
    }

    public func flatMap<U>(_ transform: @escaping (T) -> NSFuture<U>) -> NSFuture<U> {
        let (future, callback) = NSFuture<U>.create()
        self.resolved { result in
            let next = transform(result)
            next.resolved(callback)
        }
        return future
    }

    @inlinable public func after<U>(_ continuation: @escaping () -> U) -> NSFuture<U> {
        map { _ in continuation() }
    }

    @inlinable public func after<U>(_ continuation: @escaping () -> NSFuture<U>) -> NSFuture<U> {
        flatMap { _ in continuation() }
    }

    @inlinable public func dropPayload() -> NSFutureVoid {
        after { () }
    }

    @inlinable public func forward(to NSPromise: NSPromise<T>) {
        self.resolved(NSPromise.resolve)
    }

    @inlinable public func forward(to NSPromise: NSPromise<T>, on queue: DispatchQueue) {
        self.resolved { action in
            queue.async {
                NSPromise.resolve(action)
            }
        }
    }
}
