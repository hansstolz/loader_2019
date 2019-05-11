import XCTest

import loaderTests

var tests = [XCTestCaseEntry]()
tests += loaderTests.allTests()
XCTMain(tests)