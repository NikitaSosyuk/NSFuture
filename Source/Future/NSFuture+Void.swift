//
//  NSFuture+Void.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

extension NSFuture where T == Void {

    @inlinable public convenience init() {
        self.init(callback: ())
    }

    public static func fromAsyncTask(_ task: (@escaping () -> Void) -> Void) -> NSFuture {
        let (future, callback) = NSFuture.create()
        task { callback(()) }
        return future
    }
}
