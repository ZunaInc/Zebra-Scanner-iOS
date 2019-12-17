# Zebra-Scanner-iOS(Swift)

Zebra Scanner example project for iOS written in swift using a static library built on top of Zebra Scanner SDK. Tested and working on Zebra DS2278 ( BT or BLE).

### Requirement
- iOS 10 or above.
- Swift 5 or above.
- Runs only on device (Simulator not supported).

### Installation
- Download the sample project.
- Locate libZebraMultiOSScannerSwift.a file and ZebraMultiOSScannerSwift.swiftmodule(contains architecture files) directory.
- Create a new group in your new or existing project .
- Add libZebraMultiOSScannerSwift.a file and ZebraMultiOSScannerSwift.swiftmodule directory to the created group.
- Open build setting -> search for "Library Search Paths" and set the path to "$(PROJECT_DIR)/Created-Group-Name". If you have added directly to your project, the path would be "$(PROJECT_DIR)".
- Open build setting -> search for Swift Compiler - Search Path and set the "Import Paths" to "$(PROJECT_DIR)/Created-Group-Name". If you have added directly to your project, the path would be "$(PROJECT_DIR)".



### Usage

```swift
import UIKit
import ZebraMultiOSScannerSwift

class ScannerVC: UIViewController {


override func viewDidLoad() {
super.viewDidLoad()
// Do any additional setup after loading the view.
  ZebraMultiOSScannerSwift.shared.delegates = self
  ZebraMultiOSScannerSwift.shared.setUpZebraDelegates()
}

func connectScanner(scanner: SbtScannerInfo){
    ZebraMultiOSScannerSwift.shared.connectZScanner(zScanner: scanner)
}

func disconnectScanner(){
    ZebraMultiOSScannerSwift.shared.disConnectZScanner()
}

func getAllScanners(){
    ZebraMultiOSScannerSwift.shared.getCompleteZScannerList()
}

func getConnectedScannerID(){
    ZebraMultiOSScannerSwift.shared.getConnectedZScannerID()
}

}

extension ScannerVC: ScannerProtocols{

func scannerListsHasBeenUpdated(isListUpdated: Bool) {
  // Scanner List Update.
}

func scannerBarcodeEvent(scanedID: String) {
 // Scanned Barcode/QRCode id.
}

}
```



### Contact Us

- Website : [**Zuna Inc**](https://zunaco.com)
- Email : <sales@zunaco.com>
