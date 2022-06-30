//
//  ViewController.swift
//  DiffableDatasourceTableView
//
//  Created by Le Tong Minh Hieu on 30/06/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView:  UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    enum Section {
        case first
    }
    
    struct Fruit: Hashable {
        let title: String
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Fruit>!
    
    var fruits = [Fruit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.title
            return cell
        })
        title = "My Fruits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTap))
    }
    
    @objc func didTap() {
        let actionSheet = UIAlertController(title: "Select Fruit", message: nil, preferredStyle: .actionSheet)
        
        for x in 0...100 {
            actionSheet.addAction(UIAlertAction(title: "Fruit \(x+1)", style: .default, handler: { [weak self] _ in
                let fruit = Fruit(title: "Fruit \(x+1)")
                self?.fruits.append(fruit)
                self?.updateDatasource()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func updateDatasource() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Fruit>()
        snapShot.appendSections([.first])
        snapShot.appendItems(fruits)
        
        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
    }
}

