//
//
//  Created by Tapash Majumder on 8/7/18.
//  Copyright © 2018 Iterable. All rights reserved.
//

import XCTest

@testable import IterableSDK

class IterableRequestUtilTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDictToJsonData() {
        let args: [AnyHashable : Any] = [
            "email": "ilya@iterable.com",
            "device": [
                "token": "foo",
                "platform": "bar",
                "applicationName": "baz",
                "dataFields": [
                    "name": "green",
                    "localizedModel": "eggs",
                    "userInterfaceIdiom": "and",
                    "identifierForVendor": "ham",
                    "systemName": "iterable",
                    "systemVersion": "is",
                    "model": "awesome"
                ]
            ]
        ]
        
        let data = IterableRequestUtil.dictToJsonData(args)!
        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: []) as! [AnyHashable : Any]
        XCTAssertTrue(NSDictionary(dictionary: args).isEqual(to: jsonObject))
    }
    
    func testGetRequest() {
        let apiEndPoint = "https://somewhere.com/"
        let path = "path"
        let args = ["arg1" : "value1", "arg2" : "value2"]
        let request = IterableRequestUtil.createGetRequest(forApiEndPoint: apiEndPoint, path: path, args: args)!
        
        let queryParams = [
            (name: "arg1", value: "value1"),
            (name: "arg2", value: "value2"),
        ]
        TestUtils.validate(request: request, requestType: .get, apiEndPoint: apiEndPoint, path: path, queryParams: queryParams)
    }

    func testPostRequest() {
        let apiEndPoint = "https://somewhere.com/"
        let path = "path"
        let args = ["arg1" : "value1", "arg2" : "value2"]
        let body = ["var1" : "val1", "var2" : "val2"]
        let request = IterableRequestUtil.createPostRequest(forApiEndPoint: apiEndPoint, path: path, args: args, body: body)!
        
        let queryParams = [
            (name: "arg1", value: "value1"),
            (name: "arg2", value: "value2"),
            ]
        TestUtils.validate(request: request, requestType: .post, apiEndPoint: apiEndPoint, path: path, queryParams: queryParams)
        
        let bodyData = request.httpBody!

        let bodyFromRequest = try! JSONSerialization.jsonObject(with: bodyData, options: []) as! [AnyHashable : Any]
        
        TestUtils.validateElementPresent(withName: "var1", andValue: "val1", inDictionary: bodyFromRequest)
        TestUtils.validateElementPresent(withName: "var2", andValue: "val2", inDictionary: bodyFromRequest)
    }

    func testEncodeUrlQueryParam() {
        let encoded = IterableRequestUtil.encodeURLParam("you+me@iterable.com")
        XCTAssertEqual(encoded!, "you%2Bme@iterable.com")
        XCTAssertEqual(IterableRequestUtil.encodeURLParam(""), "")
        XCTAssertNil(IterableRequestUtil.encodeURLParam(nil))
    }
}
