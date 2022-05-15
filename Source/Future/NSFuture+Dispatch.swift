//
//  NSFuture+Dispatch.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

extension NSFuture {

    public func after(timeInterval: Double, on queue: DispatchQueue) -> NSFuture {
        let (future, callback) = NSFuture<T>.create()
        self.resolved { result in
            queue.asyncAfter(deadline: .now() + .milliseconds(Int(timeInterval * 1000))) {
                callback(result)
            }
        }
        return future
    }

    public func transfer(to queue: DispatchQueue) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        self.resolved { payload in
            queue.async {
                callback(payload)
            }
        }
        return future
    }

    @inlinable public static func fromAsyncTask(
        _ task: @escaping () -> T,
        after interval: TimeInterval,
        on queue: DispatchQueue
    ) -> NSFuture {
        NSFutureVoid().after(timeInterval: interval, on: queue).after(task)
    }

    @inlinable public static func fromAsyncTask(
        _ task: @escaping () -> NSFuture<T>,
        after interval: TimeInterval,
        on queue: DispatchQueue
    ) -> NSFuture {
        NSFutureVoid().after(timeInterval: interval, on: queue).after(task)
    }

    public static func fromAsyncTask(_ task: (@escaping Action<T>) -> Void) -> NSFuture {
        let (future, callback) = NSFuture<T>.create()
        task(callback)
        return future
    }

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

    public static func fromBackgroundTask<U>(
        _ task: @escaping (U) -> T,
        _ argument: U,
        executingOn executeQueue: DispatchQueue,
        resolvingOn resolveQueue: DispatchQueue
    ) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        executeQueue.async {
            let result = task(argument)
            resolveQueue.async {
                callback(result)
            }
        }
        return future
    }

    public static func wrap(_ task: (@escaping Action<T>) -> Void) -> NSFuture<T> {
        let (future, callback) = NSFuture<T>.create()
        task { callback($0) }
        return future
    }

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

    public func timingOut(
        after timeout: TimeInterval,
        on queue: DispatchQueue,
        withFallback value: T
    ) -> NSFuture {
        let fallback = NSFuture(callback: value).after(timeInterval: timeout, on: queue)
        return first(self, fallback).map { $0.value }
    }
}
