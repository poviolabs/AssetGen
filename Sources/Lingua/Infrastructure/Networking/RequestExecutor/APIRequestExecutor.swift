import Foundation

final class APIRequestExecutor {
  private let requestBuilder: URLRequestBuilder
  private let httpClient: HTTPClient
  private let jsonDecoder: JSONDecoding
  private let jsonEncoder: JSONEncoding
  private let validStatusCodes: Set<Int>
  
  init(requestBuilder: URLRequestBuilder,
       httpClient: HTTPClient = URLSessionHTTPClient(),
       jsonDecoder: JSONDecoding = JSONDecoder(),
       jsonEncoder: JSONEncoding = JSONEncoder(),
       validStatusCodes: Set<Int> = Set(200...299)) {
    self.requestBuilder = requestBuilder
    self.httpClient = httpClient
    self.jsonDecoder = jsonDecoder
    self.jsonEncoder = jsonEncoder
    self.validStatusCodes = validStatusCodes
  }
}

extension APIRequestExecutor: RequestExecutor {
  func send<R: Request>(_ request: R) async throws -> R.Response {
    let urlRequest = try requestBuilder.build(from: request)
    return try await execute(with: urlRequest)
  }
  
  private func execute<T: Decodable>(with request: URLRequest) async throws -> T {
    let (data, httpResponse) = try await httpClient.fetchData(with: request)
    
    guard validStatusCodes.contains(httpResponse.statusCode) else {
      throw InvalidHTTPResponseError(statusCode: httpResponse.statusCode, data: data)
    }
    
    return try jsonDecoder.decode(T.self, from: data)
  }
}
