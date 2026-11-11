//
//  ViewController.swift
//  SFReaderDemo
//
//  Created by Sean on 2023/9/16.
//

import UIKit
import SifliReaderOCSDK

class ViewController: UIViewController,SFReaderManagerDelegate {
   
    @IBOutlet weak var progressView: UIProgressView!
    
    let readerManager = SFReaderManager.shared();
    //通过CBCentralManager 搜索，替换成你的蓝牙设备ID
    //067BB8D9-968F-8FB2-F46F-026A0F221E2F
    private var targetIdentifier = "067BB8D9-968F-8FB2-F46F-026A0F221E2F";
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        readerManager.delegate = self
        progressView.progress = 0;
    }

    @IBAction func onClearTouCH(_ sender: Any) {
        self.readerManager.clearAssetRequest(withTargetIdentifier: targetIdentifier)
//        self.readerManager.clearAssetRequest(targetIdentifier: targetIdentifier)
    }
    
    @IBAction func onGetTouch(_ sender: Any) {
        let assetDir = deviceAssetPath()
        self.readerManager.readAssetRequest(withDir: assetDir, targetIdentifier: targetIdentifier)
//        self.readerManager.readAssetRequest(dir:assetDir, targetIdentifier: targetIdentifier)
    }
    
    @IBAction func onOnBtnTouch(_ sender: Any) {
        self.readerManager.assetOptionRequest(withOpen: true, targetIdentifier: targetIdentifier)
//        self.readerManager.assetOptionRequest(open: true, targetIdentifier: targetIdentifier)
    }
    
    
    @IBAction func onOffBtnTouch(_ sender: Any) {
        self.readerManager.assetOptionRequest(withOpen: false, targetIdentifier: targetIdentifier)
//        self.readerManager.assetOptionRequest(open: false, targetIdentifier: targetIdentifier)
    }
    

    
    func readerManager(_ manager: SFReaderManager, updateBleState state: SFBleCoreManagerState) {
        NSLog("ble 状态: \(state)")
    }
    
    func readerManager(_ manager: SFReaderManager, updateManagerState state: SFBleShellStatus) {
        NSLog("Manager 状态: \(state)")
    }
    func readerManager(_ manager: SFReaderManager,
                       progress completedBytes: UInt,
                       total totalBytes: UInt) {
        var percent:Float = 0;
        if totalBytes > 0{
            percent = Float(completedBytes) / Float(totalBytes);
        }
        progressView.progress = percent;
    }
    
    func readerManager(_ manager: SFReaderManager,
                       success: Bool,
                       errror error: SFCoreError?,
                       result: SFReadLogResult){
        var log = "task complete.success=\(success),req=\(result.requestCommand.rawValue),fileCount=\(result.rcvFiles.count)"
        NSLog(log)
    }
    
    private func DocumentPath()->String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    private func deviceAssetPath() -> String{
        let document = NSString.init(string: DocumentPath())
        let logFolder = document.appendingPathComponent("DevAssets")
        
        let manager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = manager.fileExists(atPath: logFolder, isDirectory: &isDir)
        if existed == false || isDir.boolValue == false {
            // 创建文件夹
            try? manager.createDirectory(atPath: logFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        return logFolder
    }
}

