//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import _InstructionCounter
import SwiftDiagnostics
import SwiftSyntax
import SwiftParser
import SwiftParserDiagnostics
import SwiftOperators
import Foundation
import ArgumentParser
#if os(Windows)
import WinSDK
#endif

@main
class SwiftParserCli: ParsableCommand {
  required init() {}

  static var configuration = CommandConfiguration(
    abstract: "Utility to test SwiftSyntax syntax tree creation.",
    subcommands: [
      BasicFormat.self,
      PerformanceTest.self,
      PrintDiags.self,
      PrintTree.self,
      Reduce.self,
      VerifyRoundTrip.self,
    ]
  )
}
