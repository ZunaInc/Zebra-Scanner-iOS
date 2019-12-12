//
//  AvailableScannerVC.swift
//  ZebraScannerSwift
//
//  Created by Vijay A on 28/11/19.
//  Copyright © 2019 Goalsr. All rights reserved.
//

import UIKit

class AvailableScannerVC: UIViewController {
    
    
    lazy var _tableView: UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .grouped)
        return tv
    }()
    
    var zebraScannerManager =  ConnectionManager.shared()
    var scannerList = [SbtScannerInfo]()

    
    override func viewDidLoad() {
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        self._tableView.frame = self.view.bounds
    }
    
    func initialSetup() {
        self.view.addSubview(_tableView)
        self._tableView.delegate = self
        self._tableView.dataSource = self
        zt_ScannerAppEngine.shared()?.add(self)
        self.navigationItem.title = "Available Scanners"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
        self.navigationItem.rightBarButtonItem = refreshButton
        zebraScannerManager?.initializeConnectionManager()
        self.refreshList()
    }
    
    @objc func refreshList(){
        let m_tableData = zt_ScannerAppEngine.shared()?.getAvailableScannersList()
        if let SbtScannerInfo = m_tableData as? [SbtScannerInfo]{
            scannerList = SbtScannerInfo
            _tableView.reloadData()
        }
    }
    
}

extension AvailableScannerVC :IScannerAppEngineDevListDelegate {
    //IScannerAppEngineDevListDelegate
    func scannersListHasBeenUpdated() -> Bool {
        refreshList()
        return true
    }
}



// TABLEVIEW METHODS:-

extension AvailableScannerVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = scannerList[indexPath.row].getScannerName()
        cell.detailTextLabel?.text = "not connected"
        cell.detailTextLabel?.textColor = UIColor.gray
        if (self.zebraScannerManager?.isConnected() ?? false) {
            if self.zebraScannerManager?.getConnectedScannerId()  == scannerList[indexPath.row].getScannerID() {
                cell.detailTextLabel?.text = "Connected!! click and start scanning."
                cell.detailTextLabel?.textColor = UIColor.green
            }
        }
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(self.zebraScannerManager?.isConnected() ?? false){
            self.zebraScannerManager?.connectDevice(usingScannerId: scannerList[indexPath.row].getScannerID())
            let m_tableData = zt_ScannerAppEngine.shared()?.getAvailableScannersList()
            if let SbtScannerInfo = m_tableData as? [SbtScannerInfo]{
                scannerList = SbtScannerInfo
                _tableView.reloadData()
            }
        }else{
            let ScannedBarcodeListVC = storyboard?.instantiateViewController(withIdentifier: "ScannedBarcodeListSTBID") as! ScannedBarcodeListVC
            navigationController?.pushViewController(ScannedBarcodeListVC, animated: true)
        }
        _tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (self.zebraScannerManager?.isConnected() ?? false) {
            if self.zebraScannerManager?.getConnectedScannerId()  == scannerList[indexPath.row].getScannerID() {
                let disconnect = UITableViewRowAction(style: .default, title: "disconnect") { action, index in
                    self.zebraScannerManager?.disconnect()
                    self._tableView.reloadData()
                }
                disconnect.backgroundColor = UIColor.red
                return [disconnect]
            }
        }
        return []
    }
}

