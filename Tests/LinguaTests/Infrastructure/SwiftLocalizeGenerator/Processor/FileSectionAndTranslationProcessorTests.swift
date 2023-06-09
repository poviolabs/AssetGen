import XCTest
@testable import Lingua

final class FileSectionAndTranslationProcessorTests: XCTestCase {
  func test_processAndMergeFiles_mergesResultsFromAllFileProcessors() {
    let fileManagerMock = MockFileManager(files: ["file1", "file2", "file1"])
    let sut = makeSUT(fileManagerMock: fileManagerMock)
    let path = "testDirectoryPath"
    
    let result = sut.processAndMergeFiles(at: path)
    
    XCTAssertEqual(result.sections, ["file1": Set(["section1"]), "file2": Set(["section1"])])
    XCTAssertEqual(result.translations, ["translation1": "translationValue1"])
  }
}

private extension FileSectionAndTranslationProcessorTests {
  func makeSUT(fileManagerMock: FileManager = FileManager.default,
               fileProcessors: [FileProcessor] = [MockFileProcessor()]) -> FileSectionAndTranslationProcessor {
     let fileManagerProviderMock = MockFileManagerProvider(fileManagerMock: fileManagerMock)
     return FileSectionAndTranslationProcessor(fileManagerProvider: fileManagerProviderMock, fileProcessors: fileProcessors)
   }
}
