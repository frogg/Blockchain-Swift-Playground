//#-hidden-code
import UIKit
import PlaygroundSupport
//#-end-hidden-code
//: # Hashing and Cryptography - the Math behind Blockchain.
//: Hashing is an important core concept of blockchains. It is a unique identification for digital assets, such as pictures or programing objects such as `Strings` and `Colors`. It is easy to generate a hash for a given object, but going back from the hash to the object is computationally expensive, as of today.
//: # SHA Hashing Algorithm
//: `SHA256` is the hashing algorithm that is currently used by the Bitcoin blockchain. You can generate the hash in this playground using the `.shaHash()` function on objects, such as a `String`.

let string = /*#-editable-code*/"This is a normal text string."/*#-end-editable-code*/
let hash = string.shaHash()

//: Now, run your program and see the result on the right side.

//#-hidden-code
if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
    let dict = PlaygroundValue.dictionary([
        "textString": PlaygroundValue.string(string),
        "hashString": PlaygroundValue.string(hash)])
    proxy.send(dict)
}
//#-end-hidden-code
//: [Next Page](@next)
