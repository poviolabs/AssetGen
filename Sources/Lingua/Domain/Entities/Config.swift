import Foundation

struct Config: Equatable {
  let localization: Localization?
}

extension Config {
  struct Localization: Equatable {
    let apiKey: String
    let sheetId: String
    let outputDirectory: String
    let localizedSwiftCode: LocalizedSwiftCode?
  }
  
  struct LocalizedSwiftCode: Equatable {
    let stringsDirectory: String
    let outputSwiftCodeFileDirectory: String
  }
}
