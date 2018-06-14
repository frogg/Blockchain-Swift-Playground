//#-hidden-code
import PlaygroundSupport
//#-end-hidden-code
//: # Defining a Block
//: Blocks in the blockchain are just storage units. We can easily define a new one by defining a new Swift Class. Each block has a value property that can store information (`String`).
class Block {
    var value: String
    //#-hidden-code
    init(value: String) {
        self.value = value
    }
    func shaHash() -> String {
        return value.shaHash()
    }
    //#-end-hidden-code
}

//: We are creating our first block here. Change the text to something that you want to store on the blockchain.
let block =  Block(value: /*#-editable-code*/"This is the value of the block."/*#-end-editable-code*/)

//: Blocks are also Swift objects that means we can create a unique `.shaHash()` for them. Different blocks with different values have different hashes.
block.shaHash()

//#-hidden-code
if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
    let array = PlaygroundValue.array([
        PlaygroundValue.dictionary([
            "value": PlaygroundValue.string(block.value),
            "proofOfWork": PlaygroundValue.integer(0),
            "previousHash": PlaygroundValue.string(""),
            "isChainValid": PlaygroundValue.boolean(true)
            ])
        ])
    proxy.send(array)
}
//#-end-hidden-code
//: [Next Page](@next)
