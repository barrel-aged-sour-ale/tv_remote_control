//
//  ScannerTableViewController.swift
//  TVRemoteControl
//
//  Created by Daian Aiziatov on 26/02/2019.
//  Copyright © 2019 robot64. All rights reserved.
//

import UIKit

class ScannerTableViewController: UITableViewController {

    private lazy var progressView: UIProgressView = {
        let frames = CGRect(x: 0,
                            y: (self.navigationController?.navigationBar.frame.height ?? 0) + 20,
                            width: (self.navigationController?.navigationBar.frame.width ?? 0),
                            height: 20)
        let progressView = UIProgressView(frame: frames)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    private var connectedTVs = [SystemInfo]()

    private lazy var scanner: LANScanner = {
        return LANScanner()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        let start = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startScanning))
        self.navigationItem.rightBarButtonItem = start
        scanner.delegate = self
    }

    @objc
    func startScanning() {
        connectedTVs = [SystemInfo]()
        tableView.reloadData()
        scanner.startScanForPhillipsTV()
        let stop = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopScanning))
        self.navigationItem.rightBarButtonItem = stop
        self.navigationItem.titleView = progressView
    }

    @objc
    func stopScanning() {
        scanner.stopScanning()
        let start = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startScanning))
        self.navigationItem.rightBarButtonItem = start
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedTVs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(connectedTVs[indexPath.row].ipAddress ?? "nil") - \(connectedTVs[indexPath.row].name)"
        return cell
    }

}

extension ScannerTableViewController: LANScannerDelegate {
    func lanScanDidFindNewDevice(_ device: SystemInfo) {
        self.connectedTVs.append(device)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func lanScanDidFinishScanning() {
        print("[LANScannerDelegate] \(#function) Finish")
        DispatchQueue.main.async {
            let start = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.startScanning))
            self.navigationItem.rightBarButtonItem = start
            self.navigationItem.titleView =  nil
        }
    }

    func lanScanProgressChecked(_ checkedHosts: Int, from overallHosts: Int) {
        print("[LANScannerDelegate] \(#function) checkedHost \(checkedHosts)/\(overallHosts)")
        DispatchQueue.main.async {
            self.progressView.setProgress(Float(overallHosts) / Float(checkedHosts), animated: true)
        }

    }
    
    func lanScanDidFailedToScan() {
        print("[LANScannerDelegate] \(#function) Fail")
        self.navigationItem.titleView =  nil
    }
}
