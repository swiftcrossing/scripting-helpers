// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

extension String: Error {}

@discardableResult
public func shell(_ command: String) -> Result<String, String> {
  let task = Process()
  let outputPipe = Pipe()
  let errorPipe = Pipe()

  task.standardOutput = outputPipe
  task.standardError = errorPipe
  task.arguments = ["-c", command]
  task.launchPath = "/bin/zsh"
  task.standardInput = nil
  task.launch()

  let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
  let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
  if let output = String(data: outputData, encoding: .utf8), !output.isEmpty {
    return .success(output)
  } else if let error = String(data: errorData, encoding: .utf8), !error.isEmpty {
    return .failure(error)
  }

  return .failure("Unexpected Error")
}
