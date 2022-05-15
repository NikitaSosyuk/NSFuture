//
//  DemoViewController.swift
//  NSFutureDemo
//
//  Created by Nikita Sosyuk on 15.05.2022.
//  Copyright © 2022 ITIS. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    private enum Section {
        case main
    }

    private let tableView = UITableView()

    private lazy var dataSource = UITableViewDiffableDataSource<Section, DemoModel>(
        tableView: tableView
    ) { tableView, indexPath, item in

        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SubtitleTableCell.identifier,
                for: indexPath
        ) as? SubtitleTableCell
        else { return UITableViewCell() }

        cell.setup(title: item.title, subtitle: item.subtitle)

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Примеры 😄"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SubtitleTableCell.self, forCellReuseIdentifier: SubtitleTableCell.identifier)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        setupData()
    }

    private func setupData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DemoModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(
            [
                DemoModel(
                    kind: .race,
                    title: "Гонка между NSFuture",
                    subtitle: " Отображается первая загруженная картинка"
                )
            ],
            toSection: .main
        )
        dataSource.apply(snapshot)
    }
}

// MARK: - UITableViewDelegate

extension DemoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let kind = dataSource.itemIdentifier(for: indexPath)?.kind else { return }

        let viewController: UIViewController
        switch kind {
        case .race:
            viewController = UIViewController()
        case .threeTask:
            viewController = UIViewController()
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
