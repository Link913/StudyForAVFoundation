//
//  ViewController.swift
//  AVFoundationDemo
//
//  Created by Link on 2019/6/16.
//  Copyright © 2019 Link. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var dataSource: [String] = {
        let result = ["Record and play audio."]
        return result
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.frame = view.bounds;
        view.addSubview(tableView)
    }
}

private extension ViewController {
    func getJumpVC(indexPath: IndexPath) -> UIViewController? {
        switch indexPath.row {
        case 0:
            return RecordAndPlayAudioViewController()
        default:
            return nil
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = getJumpVC(indexPath: indexPath) else { return }
        vc.title = dataSource[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}
