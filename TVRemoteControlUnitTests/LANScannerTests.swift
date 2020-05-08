// @testable import TVRemoteControl
// import XCTest
//
// class LANScannerTests: XCTestCase {
//    private var lanScanner: LANScanner!
//    private var mockTrySystemInfoLoader: MockTrySystemInfoLoader!
//    private var mockMMLanScanner: MockMMLANScanner!
//    private var mockLanScannerDelegate: MockLanScannerDelegate!
//
//    override func setUp() {
//        super.setUp()
//        mockMMLanScanner = MockMMLANScanner()
//        mockTrySystemInfoLoader = MockTrySystemInfoLoader()
//        lanScanner = LANScanner(lanScanner: mockMMLanScanner, trySystemInfoLoader: mockTrySystemInfoLoader)
//        mockLanScannerDelegate = MockLanScannerDelegate()
//        lanScanner.delegate = mockLanScannerDelegate
//    }
//
//    override func tearDown() {
//        super.tearDown()
//        mockMMLanScanner = nil
//        mockTrySystemInfoLoader = nil
//        lanScanner = nil
//        mockLanScannerDelegate = nil
//    }
//
//    func test_startScanForPhillipsTV() {
//        lanScanner.startScanForPhillipsTV()
//        XCTAssertTrue(mockMMLanScanner.isStartExecuted)
//    }
//
//    func test_stopScanning() {
//        lanScanner.stopScanning()
//        XCTAssertTrue(mockMMLanScanner.isStopExecuted)
//    }
//
//    func test_scanningForNewTV() {
//        lanScanner.startScanForPhillipsTV()
//        let device1 = MMDevice()
//        device1.ipAddress = "test1.test1.test1.test1"
//        lanScanner.lanScanDidFindNewDevice(device1)
//        let device2 = MMDevice()
//        device2.ipAddress = "test2.test2.test2.test2"
//        lanScanner.lanScanDidFindNewDevice(device2)
//
//        let finishExpectation = expectation(description: "Did finish scanning")
//        mockLanScannerDelegate.asyncExpectation = finishExpectation
//        lanScanner.lanScanDidFinishScanning(with: MMLanScannerStatusFinished)
//
//        waitForExpectations(timeout: 1) { error in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
//
//            guard self.mockLanScannerDelegate.isLanScanDidFinishScanningExecuted else {
//                XCTFail("Expected delegate to be called")
//                return
//            }
//
//            XCTAssertEqual(self.mockTrySystemInfoLoader.calledCount, 2)
//            XCTAssertTrue(self.mockTrySystemInfoLoader.calledIps.contains(device1.ipAddress))
//            XCTAssertTrue(self.mockTrySystemInfoLoader.calledIps.contains(device2.ipAddress))
//            XCTAssertEqual(self.mockLanScannerDelegate.foundedDevices.count, 1)
//            XCTAssertEqual(self.mockLanScannerDelegate.foundedDevices.first?.name, "test")
//            XCTAssertTrue(self.mockLanScannerDelegate.isLanScanDidFinishScanningExecuted)
//            XCTAssertEqual(self.mockLanScannerDelegate.overallHosts, 2)
//        }
//    }
//
//    func test_lanScanDidFailedToScan() {
//        lanScanner.lanScanDidFailedToScan()
//        XCTAssertTrue(mockLanScannerDelegate.isLanScanDidFailedToScanExecuted)
//    }
// }
//
// class MockLanScannerDelegate: LANScannerDelegate {
//    var asyncExpectation: XCTestExpectation?
//
//    var foundedDevices: [SystemInfo] = []
//    func lanScanDidFindNewDevice(_ device: SystemInfo) {
//        foundedDevices.append(device)
//    }
//
//    var isLanScanDidFinishScanningExecuted = false
//    func lanScanDidFinishScanning() {
//        guard let expectation = asyncExpectation else {
//            XCTFail("MockLanScannerDelegate was not setup correctly. Missing XCTExpectation reference")
//            return
//        }
//
//        isLanScanDidFinishScanningExecuted = true
//        expectation.fulfill()
//    }
//
//    var overallHosts: Int!
//    func lanScanProgressChecked(_: Int, from overallHosts: Int) {
//        self.overallHosts = overallHosts
//    }
//
//    var isLanScanDidFailedToScanExecuted = false
//    func lanScanDidFailedToScan() {
//        isLanScanDidFailedToScanExecuted = true
//    }
// }
//
// class MockTrySystemInfoLoader: TrySystemInfoLoading {
//    var calledCount = 0
//    var calledIps: [String] = []
//
//    func tryLoadSystemInfo(for ipAddress: String, completion: @escaping (Result<SystemInfo, DataResponseError>) -> Void) {
//        calledCount += 1
//        calledIps.append(ipAddress)
//        calledCount > 1 ? completion(Result.failure(DataResponseError.network)) : completion(Result.success(SystemInfo(name: "test", ipAddress: ipAddress)))
//    }
// }
//
// class MockMMLANScanner: MMLANScanner {
//    var isStartExecuted = false
//    override func start() {
//        isStartExecuted = true
//    }
//
//    var isStopExecuted = false
//    override func stop() {
//        isStopExecuted = true
//    }
// }
