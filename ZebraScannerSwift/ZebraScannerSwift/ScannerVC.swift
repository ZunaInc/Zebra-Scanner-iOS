//
//  ScannerVC.swift
//  ZebraScannerSwift
//
//  Created by Vijay A on 16/12/19.
//  Copyright © 2019 Goalsr. All rights reserved.
//

import UIKit
import ZebraMultiOSScannerSwift

class ScannerVC: UIViewController {
    
    var scannerList = [SbtScannerInfo]()
    var barcodeData = [String]()
    lazy var _tableView: UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .grouped)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        
    }
    
    override func viewDidLayoutSubviews() {
        self._tableView.frame = self.view.bounds
    }
    
    func initialSetup() {
        self.view.addSubview(_tableView)
        self._tableView.delegate = self
        self._tableView.dataSource = self
        ZebraMultiOSScannerSwift.shared.delegates = self
        ZebraMultiOSScannerSwift.shared.setUpZebraDelegates()
    }
    
}

// SCANNER METHODS:-

extension ScannerVC: ScannerProtocols{
    
    func scannerListsHasBeenUpdated(isListUpdated: Bool) {
        let SbtScannerInfo = ZebraMultiOSScannerSwift.shared.getCompleteZScannerList()
        scannerList = SbtScannerInfo
        _tableView.reloadData()
    }
    
    func scannerBarcodeEvent(scanedID: String) {
        barcodeData.append(scanedID)
        self._tableView.reloadData()
    }
}

// TABLEVIEW METHODS:-

extension ScannerVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return barcodeData.count
        }
        return scannerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.section == 0 {
            cell.textLabel?.text = scannerList[indexPath.row].getScannerName()
            cell.detailTextLabel?.text = "Not connected"
            cell.detailTextLabel?.textColor = UIColor.gray
            if (ZebraMultiOSScannerSwift.shared.isZScannerConnected()) {
                if ZebraMultiOSScannerSwift.shared.getConnectedZScannerID()  == scannerList[indexPath.row].getScannerID() {
                    cell.detailTextLabel?.text = "Connected"
                    cell.detailTextLabel?.textColor = UIColor.green
                }
            }
            cell.detailTextLabel?.numberOfLines = 0
            cell.accessoryType = .disclosureIndicator
        }else{
            cell.textLabel?.text = barcodeData[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if !(ZebraMultiOSScannerSwift.shared.isZScannerConnected() ){
                ZebraMultiOSScannerSwift.shared.connectZScanner(zScanner: scannerList[indexPath.row])
                let SbtScannerInfo = ZebraMultiOSScannerSwift.shared.getCompleteZScannerList()
                scannerList = SbtScannerInfo
                _tableView.reloadData()
            }
            _tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 {
            if ((ZebraMultiOSScannerSwift.shared.isZScannerConnected() )) {
                if ZebraMultiOSScannerSwift.shared.getConnectedZScannerID()  == scannerList[indexPath.row].getScannerID() {
                    let disconnect = UITableViewRowAction(style: .default, title: "disconnect") { action, index in
                        ZebraMultiOSScannerSwift.shared.disConnectZScanner()
                        self._tableView.reloadData()
                    }
                    disconnect.backgroundColor = UIColor.red
                    return [disconnect]
                }
            }
            return []
        }
        return []
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Scanners List"
        }
        return "Scanned Barcodes"
    }
}


