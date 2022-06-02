import Foundation
import TwitterAPIKit

struct Tweet: Decodable {
    let idStr: String
    let text: String
}

struct TwitterResponse<Data: Decodable>: Decodable {
    let data: Data
}

struct Status: Decodable {
    let id: String
    let text: String
    let authorId: String
}

// Block には OAuth 1.0 の token を使います.
let clientV1 = TwitterAPIKit(
    consumerKey: "",
    consumerSecret: "",
    oauthToken: "",
    oauthTokenSecret: ""
).v1

// OAuth 2 の token が必要
let client = TwitterAPIKit(.bearer("API v2 beaer token"))

let sampleStream = client.v2.sampleStream(.init(expansions: [.authorID], userFields: [.id,.username]))
let decoder = TwitterAPIKit.defaultJSONDecoder
var userIDs = Set<String>()
Task {
    for await response in sampleStream.streamResponse(queue: .global(qos: .default)) {
        if let data = response.data {


            let status = try! decoder.decode(TwitterResponse<Status>.self, from: data)
            if userIDs.contains(status.data.authorId) {
                continue
            }
            userIDs.insert(status.data.authorId)
            let blockResp = await clientV1.blockAndMute.postBlockUser(.init(user: .userID(status.data.authorId))).responseData

            if blockResp.isError {
                print(blockResp.prettyString)
            } else {
                print("Status", status.data, "Blocked", status.data.authorId)
            }

            print("Blocked", userIDs.count, "users")
        }
    }
}

RunLoop.main.run()
