//
//  ScannedBarcodeListVC.swift
//  ZebraScannerSwift
//
//  Created by Vijay A on 02/12/19.
//  Copyright © 2019 Goalsr. All rights reserved.
//

import UIKit

class ScannedBarcodeListVC: UIViewController{
    
    
    lazy var _tableView: UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .grouped)
        return tv
    }()
    
    var barCodeList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        self._tableView.frame = self.view.bounds
    }
    
    func initialSetup() {
        self.view.addSubview(_tableView)
        self._tableView.delegate = self
        self._tableView.dataSource = self
        zt_ScannerAppEngine.shared()?.add(self)
        self.navigationItem.title =  "Scanned Barcode"
        let clearButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        self.navigationItem.rightBarButtonItem = clearButton
    }

    @objc func clearList(){
        barCodeList = [String]()
        self._tableView.reloadData()
    }
    
}

// SCANNER DELEGATE METHODS:-

extension ScannedBarcodeListVC: IScannerAppEngineDevEventsDelegate{
    func scannerBarcodeEvent(_ barcodeData: Data!, barcodeType: Int32, fromScanner scannerID: Int32) {
        let decodedString = String(decoding: barcodeData, as: UTF8.self)
        print(decodedString)
        barCodeList.append(decodedString)
        self._tableView.reloadData()
    }
    
    func showScannerRelatedUI(_ scannerID: Int32, barcodeNotification barcode: Bool) {
        print(scannerID)
    }
}

// TABLEVIEW METHODS:-

extension ScannedBarcodeListVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barCodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = barCodeList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
