//
//  NSFuture.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

public final class NSFuture<T> {

    // MARK: - Nested Types

    private enum State {
        case pending([Action<T>])
        case fulfilled(T)

        static var initial: State {
            .pending([])
        }
    }

    // MARK: - Private Properties

    private var state: State

    // MARK: - Initializers

    public init(callback: T) {
        state = .fulfilled(callback)
    }

    private init() {
        state = .initial
    }

    // MARK: - Public Methods

    public static func create() -> (NSFuture<T>, callback: Action<T>) {
        let future = NSFuture<T>()
        return (future, future.accept)
    }

    public func resolved(_ callback: @escaping Action<T>) {
        switch state {
        case let .pending(callbacks):
            state = .pending(callbacks + [callback])

        case let .fulfilled(result):
            callback(result)
        }
    }

    public func unwrap() -> T? {
        switch state {
        case .pending: return nil

        case let .fulfilled(result): return result
        }
    }

    // MARK: - Private Methods

    private func accept(_ result: T) {
        guard case let .pending(callbacks) = state else { return }

        state = .fulfilled(result)
        callbacks.forEach { $0(result) }
    }
}
