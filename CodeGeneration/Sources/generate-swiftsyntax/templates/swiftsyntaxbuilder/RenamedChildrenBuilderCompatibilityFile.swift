//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax
import SwiftSyntaxBuilder
import SyntaxSupport
import Utils

let renamedChildrenBuilderCompatibilityFile = try! SourceFileSyntax(leadingTrivia: copyrightHeader) {
  DeclSyntax("import SwiftSyntax")

  for layoutNode in SYNTAX_NODES.compactMap(\.layoutNode).filter({ $0.children.hasDeprecatedChild }) {
    if let convenienceInit = try layoutNode.createConvenienceBuilderInitializer(useDeprecatedChildName: true) {
      let deprecatedNames = layoutNode.children
        .filter { !$0.isUnexpectedNodes && $0.deprecatedName != nil }
        .compactMap { $0.varOrCaseName.description }
        .joined(separator: ", ")

      DeclSyntax(
        """
        extension \(raw: layoutNode.type.syntaxBaseName) {
        @available(*, deprecated, message: "Use an initializer with \(raw: deprecatedNames) argument(s).")
        @_disfavoredOverload
        \(convenienceInit)
        }
        """
      )
    }
  }
}
