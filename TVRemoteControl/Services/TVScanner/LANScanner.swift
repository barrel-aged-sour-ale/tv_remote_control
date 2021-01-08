import Foundation

protocol LANScannerDelegate: AnyObject {
    func lanScanDidFindNewDevice(_ device: SystemInfo)
    func lanScanDidFinishScanning()
    func lanScanProgressChecked(_ checkedHosts: Int, from overallHosts: Int)
    func lanScanDidFailedToScan()
}

class LANScanner: NSObject {
    weak var delegate: LANScannerDelegate?

    private var connectedDevices: [MMDevice] = []
    private var connectedTVs: [SystemInfo] = []
    private var checkedTVsCount = 0

    private let accessQueue = DispatchQueue(label: "IncreaseTVsCount")

    lazy var lanScanner: MMLANScanner = MMLANScanner(delegate: self)
    private let trySystemInfoLoader: TrySystemInfoLoading

    init(trySystemInfoLoader: TrySystemInfoLoading) {
        self.trySystemInfoLoader = trySystemInfoLoader
    }

    func startScanForPhillipsTV() {
        lanScanner.start()
    }

    func stopScanning() {
        lanScanner.stop()
    }

    private func tryConnectedDevices() {
        for device in connectedDevices {
            tryHost(with: device.ipAddress)
        }
    }

    private func tryHost(with ipAddress: String) {
        trySystemInfoLoader.tryLoadSystemInfo(for: ipAddress) { result in
            self.accessQueue.sync {
                self.checkedTVsCount += 1
                self.delegate?.lanScanProgressChecked(self.checkedTVsCount,
                                                      from: self.connectedDevices.count)
                switch result {
                case let .failure(error):
                    print("[API] Failure: error: \(error.localizedDescription)")
                case let .success(response):
                    self.delegate?.lanScanDidFindNewDevice(response)
                    print("[API] Success: response \(response)")
                }
                if self.checkedTVsCount == self.connectedDevices.count {
                    self.checkedTVsCount = 0
                    self.delegate?.lanScanDidFinishScanning()
                    print("[API] Process is complited")
                }
            }
        }
    }
}

// MARK: - MMLANScannerDelegate

extension LANScanner: MMLANScannerDelegate {
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        if !connectedDevices.contains(device) {
            connectedDevices.append(device)
        }
        print("[MMLANScannerDelegate] \(#function) \(device.ipAddress ?? "nil")")
    }

    func lanScanDidFinishScanning(with _: MMLanScannerStatus) {
        print("[MMLANScannerDelegate] \(#function) SCAN finished, TryingHosts Started")
        tryConnectedDevices()
    }

    func lanScanDidFailedToScan() {
        delegate?.lanScanDidFailedToScan()
        print("[MMLANScannerDelegate] \(#function) SCAN failed")
    }
}
