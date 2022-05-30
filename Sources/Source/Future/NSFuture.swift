//
//  NSFuture.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

/// Сущность которая инкапсулирует в себе замыкания.
public final class NSFuture<T> {

    // MARK: - Nested Types

    /// Возможные состояния NSFuture.
    private enum State {
        /// В процессе выполнения, в ассоциированном типе хранятся замыкания, которые необходимо выполнить.
        case pending([Action<T>])
        /// Выполнена, в ассоциированном типе хранится значение.
        case fulfilled(T)

        static var initial: State {
            .pending([])
        }
    }

    // MARK: - Private Properties

    private var state: State

    // MARK: - Initializers

    /// Инициализатор сущности.
    ///
    /// - Parameters:
    ///   - callback: Замыкание, которое выполниться после окончания основной задачи.
    public init(callback: T) {
        state = .fulfilled(callback)
    }

    private init() {
        state = .initial
    }

    // MARK: - Public Methods

    /// Функция, позволяющая создать пустую сущность и обработать замыкание позже.
    public static func create() -> (NSFuture<T>, callback: Action<T>) {
        let future = NSFuture<T>()
        return (future, future.accept)
    }

    /// Функция, позволяющая добавить замыкание, которое выполнится после выполнения основной задачи.
    public func resolved(_ callback: @escaping Action<T>) {
        switch state {
        case let .pending(callbacks):
            state = .pending(callbacks + [callback])

        case let .fulfilled(result):
            callback(result)
        }
    }

    /// Функция, позволяющая получить опциональное значение, если задача выполнена.
    public func unwrap() -> T? {
        switch state {
        case .pending: return nil

        case let .fulfilled(result): return result
        }
    }

    /// Функция, позволяющий прикинуть себя в результат  `NSPromise`.
    @inlinable public func forward(to promise: NSPromise<T>) {
        self.resolved(promise.resolve)
    }

    /// Функция, позволяющий прикинуть себя в результат  `NSPromise`, исполняемой на конкретной очереди.
    @inlinable public func forward(to promise: NSPromise<T>, on queue: DispatchQueue) {
        self.resolved { action in
            queue.async {
                promise.resolve(action)
            }
        }
    }

    // MARK: - Private Methods

    private func accept(_ result: T) {
        guard case let .pending(callbacks) = state else { return }

        state = .fulfilled(result)
        callbacks.forEach { $0(result) }
    }
}
