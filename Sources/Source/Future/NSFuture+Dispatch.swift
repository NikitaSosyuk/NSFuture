//
//  NSFuture+Dispatch.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

extension NSFuture {

    /// Функция, позволяющая отложить выполнение замыкания после определенного промежутка времени.
    /// - Parameters:
    ///   - timeInterval: Значение времени, на которое необходимо отложить выполнение.
    ///   - on: `DispatchQueue` на которой будет исполнено замыкание.
    public func after(timeInterval: Double, on queue: DispatchQueue) -> NSFuture {
        let (future, callback) = NSFuture<T>.create()
        self.resolved { result in
            queue.asyncAfter(deadline: .now() + .milliseconds(Int(timeInterval * 1000))) {
                callback(result)
            }
        }
        return future
    }

    /// Функция, позволяющая перенести выполнение замыкания на другую очередь.
    /// - Parameters:
    ///   - to: `DispatchQueue` на которой будет исполнено замыкание.
    public func transfer(to queue: DispatchQueue) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        self.resolved { payload in
            queue.async {
                callback(payload)
            }
        }
        return future
    }

    /// Функция, позволяющая создать `NSFuture` из замыкания.
    /// - Parameters:
    ///   - task: Замыкание, которое будет трансформировано в `NSFuture`.
    ///   - after: Значение времени, на которое необходимо отложить выполнение.
    ///   - on: `DispatchQueue` на которой будет исполнено замыкание.
    @inlinable public static func fromAsyncTask(
        _ task: @escaping () -> T,
        after interval: TimeInterval,
        on queue: DispatchQueue
    ) -> NSFuture {
        NSFutureVoid().after(timeInterval: interval, on: queue).after(task)
    }

    /// Функция, позволяющая создать `NSFuture` из замыкания, создающего другой экземпляр `NSFuture` .
    /// - Parameters:
    ///   - task: Замыкание, которое будет трансформировано в `NSFuture`.
    ///   - after: Значение времени, на которое необходимо отложить выполнение.
    ///   - on: `DispatchQueue` на которой будет исполнено замыкание.
    @inlinable public static func fromAsyncTask(
        _ task: @escaping () -> NSFuture<T>,
        after interval: TimeInterval,
        on queue: DispatchQueue
    ) -> NSFuture {
        NSFutureVoid().after(timeInterval: interval, on: queue).after(task)
    }

    /// Функция, позволяющая создать `NSFuture` из замыкания, в котором приходит замыкание.
    /// - Parameters:
    ///   - task: Замыкание, которое будет трансформировано в `NSFuture`.
    public static func fromAsyncTask(_ task: (@escaping Action<T>) -> Void) -> NSFuture {
        let (future, callback) = NSFuture<T>.create()
        task(callback)
        return future
    }

    /// Функция, позволяющая создать `NSFuture` из замыкания с разным вариантом исполняемых очередей.
    /// - Parameters:
    ///   - task: Замыкание, которое создает `NSFuture`.
    ///   - executeOn: `DispatchQueue` на которой будет исполнена задача.
    ///   - resolveOn: `DispatchQueue` на которой будет исполнены замыкания.
    public static func fromAsyncBackgroundTask(
        _ task: @escaping () -> NSFuture<T>,
        executeOn executeQueue: DispatchQueue,
        resolveOn resolveQueue: DispatchQueue
    ) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        executeQueue.async {
            let taskComplete = task()
            taskComplete.resolved { action in
                resolveQueue.async {
                    callback(action)
                }
            }
        }
        return future
    }

    /// Функция, позволяющая создать `NSFuture` из замыкания с разным вариантом исполняемых очередей.
    /// - Parameters:
    ///   - task: Замыкание, которое будет трансформировано в `NSFuture`.
    ///   - executeOn: `DispatchQueue` на которой будет исполнена задача.
    ///   - resolveOn: `DispatchQueue` на которой будет исполнены замыкания.
    public static func fromBackgroundTask(
        _ task: @escaping () -> T,
        executingOn executeQueue: DispatchQueue,
        resolvingOn resolveQueue: DispatchQueue
    ) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        executeQueue.async {
            let result = task()
            resolveQueue.async {
                callback(result)
            }
        }
        return future
    }

    /// Функция, позволяющая обернуть замыкание в `NSFuture`.
    /// - Parameters:
    ///   - task: Замыкание, которое будет трансформировано в `NSFuture`.
    public static func wrap(_ task: (@escaping Action<T>) -> Void) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        task { callback($0) }
        return future
    }

    /// Функция, позволяющая обернуть несколько замыканий замыкание в `NSFuture`.
    /// - Parameters:
    ///   - task: Замыкание, которое будет трансформировано в `NSFuture`.
    ///   - p1: Первый параметр, который будет обернут.
    ///   - p2: Второй параметр, который будет обернут.
    public static func wrap<T1, T2>(
        _ task: (T1, T2, @escaping Action<T>) -> Void,
        _ p1: T1,
        _ p2: T2
    ) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        task(p1, p2) { callback($0) }
        return future
    }

    public static func resolved(_ payload: T) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        callback(payload)
        return future
    }
}
