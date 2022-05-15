//
//  DemoModel.swift
//  NSFutureDemo
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import Foundation

struct DemoModel: Hashable {
    enum Kind {
        case race
        case threeTask
    }

    let kind: Kind
    let title: String
    let subtitle: String
}
