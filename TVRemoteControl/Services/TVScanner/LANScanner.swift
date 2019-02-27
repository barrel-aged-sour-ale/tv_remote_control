import Foundation

protocol LANScannerDelegate: AnyObject {
    func lanScanDidFindNewDevice(_ device: SystemInfo)
    func lanScanDidFinishScanning()
    func lanScanProgressChecked(_ checkedHosts: Int, from overallHosts: Int)
    func lanScanDidFailedToScan()
}

class LANScanner: NSObject {

    weak var delegate: LANScannerDelegate?

    var isScanRunning = false

    private var connectedDevices = [MMDevice]()
    private var connectedTVs = [SystemInfo]()
    private var checkedTVsCount = 0
    private let accessQueue = DispatchQueue(label: "IncreaseTVsCount")

    private lazy var lanScanner: MMLANScanner = {
        return MMLANScanner(delegate: self)
    }()

    func startScanForPhillipsTV() {
        self.isScanRunning = true
        lanScanner.start()
    }

    func stopScanning() {
        self.isScanRunning = false
        lanScanner.stop()
    }

    private func tryConnectedDevices() {
        for index in 0..<connectedDevices.count {
            tryHost(with: connectedDevices[index].ipAddress)
        }
    }

    private func tryHost(with ipAddress: String) {
        let client = APIClient(ipAddress: ipAddress)
        client.fetchingSystemInfo { result in
            guard let delegate = self.delegate else {
                return
            }
            self.accessQueue.sync {
                self.checkedTVsCount += 1
                delegate.lanScanProgressChecked(self.checkedTVsCount,
                                                from: self.connectedDevices.count)
            }
            switch result {
            case .failure(let error):
                print("[API] Failure: error: \(error.reason)")
            case .success(let response):
                delegate.lanScanDidFindNewDevice(response)
                print("[API] Success: response \(response)")
            }
            if self.checkedTVsCount == self.connectedDevices.count {
                self.accessQueue.sync {
                    self.checkedTVsCount = 0
                }
                self.isScanRunning = false
                delegate.lanScanDidFinishScanning()
                print("[API] Process is complited")
            }
        }
    }
}

// MARK: - MMLANScannerDelegate
extension LANScanner: MMLANScannerDelegate {

    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        if !self.connectedDevices.contains(device) {
            self.connectedDevices.append(device)
        }
        print("[MMLANScannerDelegate] \(#function) \(device.ipAddress ?? "nil")")
    }

    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        print("[MMLANScannerDelegate] \(#function) SCAN finished, TryingHosts Started")
        self.tryConnectedDevices()
    }

    func lanScanDidFailedToScan() {
        guard let delegate = delegate else {
            return
        }
        delegate.lanScanDidFailedToScan()
        self.isScanRunning = false
        print("[MMLANScannerDelegate] \(#function) SCAN failed")
    }

}

