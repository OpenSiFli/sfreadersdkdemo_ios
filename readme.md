# SifliReaderOCSDK 使用说明

## 1. 概述

SifliReaderOCSDK 提供从手表端读取Log,Asset等功能

## 2. 集成

将SifliReaderOCSDK.framework，SifliOCore.framework导入项目之中，在General选择Do Not Embed.

Swit Package

```
https://github.com/OpenSiFli/SifliOCore.git
https://github.com/OpenSiFli/siflireadersdk_ios.git
```

info.plist 需要蓝牙权限声明

Privacy - Bluetooth Always Usage Description

## 3. 如何使用

SFReaderSDK 开放一个单例SFReaderManager 作为接口对象。

初始化

```swift
let readerManager = SFReaderManager.share;
readerManager.delegate = self
```

### 3.1. 实现回调

```objective-c
@protocol SFReaderManagerDelegate <NSObject>

- (void)readerManager:(SFReaderManager *)manager updateBleState:(SFBleCoreManagerState)state;
- (void)readerManager:(SFReaderManager *)manager
               progress:(NSUInteger)completedBytes
              total:(NSUInteger)totalBytes;

/// 视频预览完成回调
/// - Parameters:
///   - manager:
///   - success:是否成功，失败时error有值。
///   - error: @see SFCoreError
///   - result:@see SFReadLogResult
- (void)readerManager:(SFReaderManager *)manager success:(BOOL)success errror:(nullable SFCoreError *)error result:(nonnull SFReadLogResult *)result;
- (void)readerManager:(SFReaderManager *)manager updateManagerState:(SFBleShellStatus)state;

@end
```

SFReaderSDK通过回调通知sdk的状态，读取进度，任务执行结果。

响应结果对象

```objective-c
@interface SFReadLogResult : NSObject

@property (nonatomic, assign) SFReaderCommandType requestCommand;
@property (nonatomic, assign) SFReaderCommandType responseCommand;

/// 单条请求数据响应
@property (nonatomic, strong, nullable) SFReaderResponsePacket *responsePacket;

/// 已接收到的文件列表（只读）
@property (nonatomic, copy, readonly) NSArray<NSString *> *rcvFiles;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithRequestCommand:(SFReaderCommandType)requestCommand;

/// 追加接收到的文件
- (void)appendFiles:(NSArray<NSString *> *)files;

@end
```

reqeustCommand为请求命令,文件读取成功后将会放置在rcvFiles中

### 3.2. Asset

**设置asset 开关**

```swift
self.readerManager.assetOptionRequest(open: true, targetIdentifier: targetIdentifier)
```

**其中open为true/false,targetIdentifier为目标设备地址**

**读取Asset**

```swift
self.readerManager.readAssetRequest(dir:assetDir, targetIdentifier: targetIdentifier)
```

**其中assetDir为读取文件存放目录，targetIdentifier为目标设备地址**

**读取成功后，文件地址通过回调通知**

```swift
func readerManager(manager: SFReaderSDK.SFReaderManager, complete result: SFReaderSDK.SFReadLogResult, success: Bool, error: SFReaderSDK.SFReaderError?)
```

文件地址在result.rcvFiles 列表之中。

### 3.3 AudioDump
### 读取AudioDump
```java
public void readAudioDumpRequest(String dir, String mac);
```
其中 dir 为读取文件存放目录，mac 为目标设备地址。

### 选择AudioDump类型
```objective-c
- (void)openAudioDumpRequestWithType:(SFReaderAudioDumpType)type
                    targetIdentifier:(NSString *)targetIdentifier;
```
```objective-c
typedef NS_ENUM(NSInteger, SFReaderAudioDumpType) {
    SFReaderAudioDumpTypeDOWLINK       = 1,
    SFReaderAudioDumpTypeDOWLINK_AGC   = 2,
    SFReaderAudioDumpTypeAUDPRC        = 3,
    SFReaderAudioDumpTypeDC_OUTPUT     = 4,
    SFReaderAudioDumpTypeRAMP_IN_OUTPUT= 5,
    SFReaderAudioDumpTypeAECM_INPUT1   = 6,
    SFReaderAudioDumpTypeAECM_INPUT2   = 7,
    SFReaderAudioDumpTypeAECM_OUTPUT   = 8,
    SFReaderAudioDumpTypeANC_OUTPUT    = 9,
    SFReaderAudioDumpTypeAGC_OUTPUT    = 10,
    SFReaderAudioDumpTypeRAMP_OUT_OUTPUT = 11
};
```
### 清理 Dump

```objective-c
- (void)clearAudioDumpRequestWithTargetIdentifier:(NSString *)targetIdentifier;
```

## 4. 异常代码

```objective-c
typedef NS_ENUM(NSInteger, SFReaderErrorType) {
    // 与 QError 保持一致
    SFReaderErrorTypeUnknown              = 200,
    SFReaderErrorTypeConnectTimeout       = 201,
    SFReaderErrorTypeConnectionCanceled   = 202,
    SFReaderErrorTypeDisconnected         = 203,
    SFReaderErrorTypeFailedToConnect      = 204,
    
    SFReaderErrorTypeGeneral              = 205,
    SFReaderErrorTypeSearchTimeout        = 206,  // 搜索设备超时
    SFReaderErrorTypeRequestTimeout       = 207,  // 请求超时
    SFReaderErrorTypeErrorCodeFromDevice  = 208,  // 设备错误码
    SFReaderErrorTypeInsufficientBytes    = 209,  // 收到数据长度不正确
    SFReaderErrorTypeUnavailableBleStatus = 210, // 蓝牙状态异常
    SFReaderErrorTypeInvalidParams        = 211, // 无效参数
    SFReaderErrorTypeOutOfRange           = 212, // 数据超出范围
    SFReaderErrorTypeFailToWriteFile      = 213, // 写入文件失败
    SFReaderErrorTypeFailToParsePacket    = 214, // 解析响应数据失败
    SFReaderErrorTypeFailToGetWatchInfo   = 215,  // 没有获取到手表信息
    SFReaderErrorTypeFailToParseAudioDumpGetRsp = 216,//解析数据失败
    SFReaderErrorTypeFailToParseAudioDumpGetRspFileName = 217,
    SFReaderErrorTypeFailToParseDataPacket = 218,
    SFReaderErrorTypeFailToParseLogGetStartRsp = 219,
    SFReaderErrorTypeInvalidRequestPacketParam = 220,
    SFReaderErrorTypeInvalidResponoseBytes = 230
};
```
