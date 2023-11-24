//
//  LinkedListTest.swift
//  DataStructureTests
//
//  Created by Iman Mosayyebi on 11/17/23.
//

import XCTest
@testable import DataStructure

final class LinkedListTest: XCTestCase {
    
    var testList: LinkedList<Int>!
    
    override func setUpWithError() throws {
        testList = LinkedList<Int>()
    }

    override func tearDownWithError() throws {
        testList =  nil
    }
    
    func testCheckEmptyListSize() {
        XCTAssertEqual(testList.count, 0, "Some thing went wrong")
    }
    
    func testAddNode() {
        testList = LinkedList<Int>([1, 2, 3, 4, 5, 6, 7, 8])
        testList.add(9)
        testList.add(10)
        XCTAssertEqual(testList.count, 10, "Some thing went wrong")
    }
    
    func testRemoveNode() {
        testList = LinkedList<Int>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        testList.remove(2)
        let first = testList.removeFirst()
        XCTAssertEqual(first, 1, "Some thing went wrong")
        let last = testList.removeLast()
        XCTAssertEqual(last, 10, "Some thing went wrong")
        let nowFirst = testList.getFirst()
        XCTAssertEqual(nowFirst, 3, "Some thing went wrong")
        let nowLast = testList.getLast()
        XCTAssertEqual(nowLast, 9, "Some thing went wrong")
        XCTAssertEqual(testList.count, 7, "Some thing went wrong")
    }
    
    func testAddAll() {
        testList = LinkedList<Int>([1, 2, 3, 4, 5])
        testList.addAll(index: 3, [20,  30, 40, 50,  60])
        XCTAssertEqual(testList.count, 10, "Some thing went wrong")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
