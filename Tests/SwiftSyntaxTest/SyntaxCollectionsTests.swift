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

import XCTest
import SwiftSyntax
import _SwiftSyntaxTestSupport

fileprivate func integerLiteralElement(_ int: Int) -> ArrayElementSyntax {
  let literal = TokenSyntax.integerLiteral("\(int)")
  return ArrayElementSyntax(
    expression: IntegerLiteralExprSyntax(literal: literal)
  )
}

public class SyntaxCollectionsTests: XCTestCase {

  public func testAppendingElement() {
    let arrayElementList = ArrayElementListSyntax([
      integerLiteralElement(0)
    ])

    let newArrayElementList = ArrayElementListSyntax(arrayElementList + [integerLiteralElement(1)])
    XCTAssert(newArrayElementList.kind.isSyntaxCollection)
    XCTAssertEqual(newArrayElementList.count, 2)
    XCTAssertNotNil(newArrayElementList.child(at: 1))
    XCTAssert(!newArrayElementList.child(at: 1)!.kind.isSyntaxCollection)
    XCTAssertEqual("\(newArrayElementList.child(at: 1)!)", "1")
  }

  public func testInsertingElement() {
    let arrayElementList = ArrayElementListSyntax([
      integerLiteralElement(1)
    ])

    var newArrayElementList = ArrayElementListSyntax([integerLiteralElement(0)] + arrayElementList)

    XCTAssertEqual(newArrayElementList.count, 2)
    XCTAssertNotNil(newArrayElementList.child(at: 0))
    XCTAssertEqual("\(newArrayElementList.child(at: 0)!)", "0")

    newArrayElementList = ArrayElementListSyntax(newArrayElementList + [integerLiteralElement(2)])

    XCTAssertEqual(newArrayElementList.count, 3)
    XCTAssertNotNil(newArrayElementList.child(at: 2))
    XCTAssertEqual("\(newArrayElementList.child(at: 2)!)", "2")
  }

  public func testPrependingElement() {
    let arrayElementList = ArrayElementListSyntax([
      integerLiteralElement(1)
    ])

    let newArrayElementList = ArrayElementListSyntax([integerLiteralElement(0)] + arrayElementList)

    XCTAssertEqual(newArrayElementList.count, 2)
    XCTAssertNotNil(newArrayElementList.child(at: 0))
    XCTAssertEqual("\(newArrayElementList.child(at: 0)!)", "0")
  }

  public func testRemovingFirstElement() {
    let arrayElementList = ArrayElementListSyntax([
      integerLiteralElement(0),
      integerLiteralElement(1),
    ])

    let newArrayElementList = ArrayElementListSyntax(arrayElementList.dropFirst())

    XCTAssertEqual(newArrayElementList.count, 1)
    XCTAssertNotNil(newArrayElementList.child(at: 0))
    XCTAssertEqual("\(newArrayElementList.child(at: 0)!)", "1")
  }

  public func testRemovingLastElement() {
    let arrayElementList = ArrayElementListSyntax([
      integerLiteralElement(0),
      integerLiteralElement(1),
    ])

    let newArrayElementList = ArrayElementListSyntax(arrayElementList.dropLast())

    XCTAssertEqual(newArrayElementList.count, 1)
    XCTAssertNotNil(newArrayElementList.child(at: 0))
    XCTAssertEqual("\(newArrayElementList.child(at: 0)!)", "0")
  }

  public func testRemovingElement() {
    let arrayElementList = ArrayElementListSyntax([
      integerLiteralElement(0)
    ])

    let newArrayElementList = ArrayElementListSyntax(arrayElementList.dropFirst())

    XCTAssertEqual(newArrayElementList.count, 0)
    XCTAssertNil(newArrayElementList.child(at: 0))
  }

  public func testReplacingElement() {
    let arrayElementList = ArrayElementListSyntax([
      integerLiteralElement(0),
      integerLiteralElement(1),
      integerLiteralElement(2),
    ])

    let lastElementIndex = arrayElementList.index(arrayElementList.startIndex, offsetBy: 2)

    let newArrayElementList = arrayElementList.with(
      \.[lastElementIndex],
      integerLiteralElement(3)
    )

    XCTAssertNotNil(newArrayElementList.child(at: 2))
    XCTAssertEqual("\(newArrayElementList.child(at: 2)!)", "3")
  }

  public func testIteration() {
    let arrayElementList = ArrayElementListSyntax([
      integerLiteralElement(0),
      integerLiteralElement(1),
      integerLiteralElement(2),
    ])

    let elems = Array(arrayElementList)
    XCTAssertEqual(elems.count, 3)
    guard elems.count == 3 else {
      return
    }
    XCTAssertEqual("\(elems[0])", "0")
    XCTAssertEqual("\(elems[1])", "1")
    XCTAssertEqual("\(elems[2])", "2")

    let relems = Array(arrayElementList.reversed())
    XCTAssertEqual(relems.count, 3)
    guard relems.count == 3 else {
      return
    }
    XCTAssertEqual("\(relems[2])", "0")
    XCTAssertEqual("\(relems[1])", "1")
    XCTAssertEqual("\(relems[0])", "2")
  }
}
