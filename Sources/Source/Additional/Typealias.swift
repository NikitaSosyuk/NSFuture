//
//  Typealias.swift
//  NSFuture
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

public typealias Action<T> = (T) -> Void
public typealias NSFutureVoid = NSFuture<Void>
public typealias NSFutureArray<T> = NSFuture<[T]>
