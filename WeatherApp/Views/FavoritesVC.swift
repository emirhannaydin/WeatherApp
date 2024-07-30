//
//  FavoritesVC.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 10.07.2024.
//

import UIKit

final class FavoritesVC: UIViewController {
    
    let tableView = UITableView()
    var favoritesCity = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        favoritesCity = defaults.stringArray(forKey: "favoriteCities") ?? []
        tableView.reloadData()

    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FTableViewCell.self, forCellReuseIdentifier: FTableViewCell.identifier)
    }
    
    func configureView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        view.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(red: 172/255, green: 255/255, blue: 251/255, alpha: 1.0)

    }
    
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default))
            self.present(alertVC, animated: true)
        }
    }
    
    
}

