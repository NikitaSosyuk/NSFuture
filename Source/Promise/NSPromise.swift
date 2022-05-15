//
//  NSPromise.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

public final class NSPromise<T> {

    // MARK: - Public Properties
    
    public let future: NSFuture<T>

    // MARK: - Private Properties

    private let feed: Action<T>

    // MARK: - Initializer

    public init() {
        (future, feed) = NSFuture<T>.create()
    }

    // MARK: - Public Methods

    public func resolve(_ callback: T) {
        feed(callback)
    }
}

extension NSPromise where T == Void {

    public func resolve() {
        resolve(())
    }
}
