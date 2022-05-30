//
//  SaveViewController.swift
//  NSFutureDemo
//
//  Created by Nikita Sosyuk on 21.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import UIKit
import NSFuture

final class SaveViewController: UIViewController {

    private let filePath = "123"
    private let fileManager = FileManager.default
    private let button = UIButton(configuration: .filled())

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        isFileExist().resolved { [weak self] isExist in
            guard !isExist else { return }
            self?.showBanner()
        }

        DispatchQueue.global(qos: .utility).async { [fileManager, filePath] in
            if fileManager.fileExists(atPath: filePath) {
                DispatchQueue.main.async { [weak self] in
                    self?.showBanner()
                }
            }
        }
    }

    // MARK: - Private Methods

    private func showBanner() {

    }

    private func isFileExist() -> NSFuture<Bool> {
        NSFuture.fromBackgroundTask(
            { [fileManager, filePath] in
                fileManager.fileExists(atPath: filePath)
            },
            executingOn: .global(qos: .utility),
            resolvingOn: .main
        )
    }

    private func getFile() -> NSFuture<Data?> {
        NSFuture.fromBackgroundTask(
            { [fileManager, filePath] in
                fileManager.contents(atPath: filePath)
            },
            executingOn: .global(qos: .utility),
            resolvingOn: .main
        )
    }
}
