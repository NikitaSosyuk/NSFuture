//
//  RaceViewController.swift
//  NSFutureDemo
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import UIKit
import NSFuture
import SnapKit

final class RaceViewController: UIViewController {

    private let imageView = UIImageView()
    private let button = UIButton(configuration: .filled())
    private let catURL = URL(string: "https://i.artfile.ru/3634x2725_631843_[www.ArtFile.ru].jpg")!
    private let dogURL = URL(string: "https://i1.wallbox.ru/wallpapers/main2/201715/vzglad-sobaka-sarf.jpg")!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)
        view.addSubview(imageView)
        view.backgroundColor = .white

        button.setTitle("Download Image", for: .normal)
        button.addTarget(self, action: #selector(fetchImages), for: .touchUpInside)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }

    @objc
    private func fetchImages() {
        let catFuture = fetchImage(for: catURL)
        let dogFuture = fetchImage(for: dogURL)

        first(catFuture, dogFuture)
            .transfer(to: .main)
            .resolved { [weak self] result in
                self?.imageView.image = result.value
            }
    }

    private func fetchImage(for url: URL) -> NSFuture<UIImage> {
        let promise = NSPromise<UIImage>()

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil,
                  let image = UIImage(data: data)
            else { return }

            promise.resolve(image)
        }.resume()

        return promise.future
    }
}
