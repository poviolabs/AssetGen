import XCTest
@testable import AssetGen

final class LocalizedilesGeneratorTests: XCTestCase {
  func test_generate_callsExpectedMethods() throws {
    let directoryOperator = MockDirectoryOperator()
    let filesGenerator = MockPlatformFilesGenerator()
    let localizationPlatform = LocalizationPlatform.ios
    
    let sut = LocalizedFilesGenerator(
      directoryOperator: directoryOperator,
      filesGenerator: filesGenerator,
      localizationPlatform: localizationPlatform
    )
    
    let sheet = LocalizationSheet(language: "en", entries: [LocalizationEntry.create(plural: true)])
    let config = AssetGenConfig.Localization(apiKey: "key", sheetId: "id", outputDirectory: "path")
    
    try sut.generate(for: sheet, config: config)
    
    XCTAssertEqual(directoryOperator.messages,
                   [.createDirectory(localizationPlatform.folderName(for: sheet.languageCode), config.outputDirectory)])
  }
}
