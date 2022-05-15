//
//  NSFuture+Higher-order.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

extension NSFuture {

    /// Функция, позволяющий преобразовать результат `NSFuture`.
    /// - Parameters:
    ///   - transform: Замыкание, принимающее результат предыдущего `NSFuture` и преобразующее в другой тип.
    public func map<U>(_ transform: @escaping (T) -> U) -> NSFuture<U> {
        let (future, callback) = NSFuture<U>.create()
        self.resolved { action in
            callback(transform(action))
        }
        return future
    }

    /// Функция, позволяющий преобразовать все вложенные `NSFuture` у `NSFuture` в единую сущность.
    /// - Parameters:
    ///   - transform: Замыкание, принимающее результат предыдущее `NSFuture` и преобразующее в другой тип.
    public func flatMap<U>(_ transform: @escaping (T) -> NSFuture<U>) -> NSFuture<U> {
        let (future, callback) = NSFuture<U>.create()
        self.resolved { result in
            let next = transform(result)
            next.resolved(callback)
        }
        return future
    }

    /// Функция, позволяющий добавить замыкание, которое выполнится после`NSFuture`.
    /// - Parameters:
    ///   - continuation: Замыкание.
    @inlinable public func after<U>(_ continuation: @escaping () -> U) -> NSFuture<U> {
        map { _ in continuation() }
    }

    /// Функция, позволяющий добавить замыкание, которое выполнится после`NSFuture`.
    /// - Parameters:
    ///   - continuation: Замыкание создающее `NSFuture`.
    @inlinable public func after<U>(_ continuation: @escaping () -> NSFuture<U>) -> NSFuture<U> {
        flatMap { _ in continuation() }
    }

    /// Функция, позволяющий опустить результирующий тип.
    @inlinable public func dropPayload() -> NSFutureVoid {
        after { () }
    }
}
