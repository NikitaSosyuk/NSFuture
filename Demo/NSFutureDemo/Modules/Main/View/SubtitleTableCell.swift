//
//  SubtitleTableCell.swift
//  NSFutureDemo
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import UIKit

final class SubtitleTableCell: UITableViewCell {

    static let identifier = "SubtitleTableCell"

    private let title = UILabel()
    private let subtitle = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(title)
        addSubview(subtitle)

        title.numberOfLines = .zero
        title.textAlignment = .left
        subtitle.textAlignment = .left
        subtitle.numberOfLines = .zero
        subtitle.textColor = .systemGray
        title.font = .systemFont(ofSize: 15, weight: .bold)
        subtitle.font = .systemFont(ofSize: 12, weight: .regular)

        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        title.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate(
            [
                title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

                subtitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                subtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
                subtitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(title: String, subtitle: String) {
        self.title.text = title
        self.subtitle.text = subtitle
    }
}
