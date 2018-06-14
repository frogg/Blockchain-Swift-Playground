//#-hidden-code
import PlaygroundSupport
//#-end-hidden-code
//: # Creating a Block-Chain
//: Now we want to link multiple blocks with each other in order to create a chain. We do that by pointing to the previous block and storing the hash of the previous block as well.
class Block {
    var value: String
    var previousBlock: Block?
    var previousHash: String?
    //#-hidden-code
    let isFirstBlock: Bool
    init(value: String, previousBlock: Block?, previousHash: String?) {
        self.value = value
        self.previousBlock = previousBlock
        self.previousHash = previousHash
        isFirstBlock = (previousBlock == nil && previousHash == nil)
    }
    func shaHash() -> String {
        return "\(value)\(previousHash)".shaHash()
    }
    //#-end-hidden-code
}

let block1 =  Block(value: /*#-editable-code*/"Frederik paid 3 Bitcoin to Larissa."/*#-end-editable-code*/, previousBlock: nil, previousHash: nil)
let block2 =  Block(value: /*#-editable-code*/"Larissa paid 1 Bitcoin to Markus."/*#-end-editable-code*/, previousBlock: block1, previousHash: block1.shaHash())
let block3 =  Block(value: /*#-editable-code*/"Markus paid 2 Bitcoin to Robbie."/*#-end-editable-code*/, previousBlock: block2, previousHash: block2.shaHash())

//: We can now check if the chain has been manipulated by comparing the actual hash of the previous block to the stored `previousHash` value:
extension Block {
    func isChainValid() -> Bool {
        if isFirstBlock {
            return true
        }
        return previousHash! == previousBlock!.shaHash() && previousBlock!.isChainValid()
    }
}

block3.isChainValid()

//#-hidden-code
if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
    
    var proxyArray = Array<PlaygroundValue>()
    var currentBlock:Block? = block3
    while currentBlock != nil {
        proxyArray.append(PlaygroundValue.dictionary([
            "value": PlaygroundValue.string(currentBlock!.value),
            "proofOfWork": PlaygroundValue.integer(0),
            "previousHash": PlaygroundValue.string(""),
            "isChainValid": PlaygroundValue.boolean(true)
            ]))
        currentBlock = currentBlock!.previousBlock
    }
    
    let array = PlaygroundValue.array(proxyArray.reversed())
    proxy.send(array)
}
//#-end-hidden-code
//: [Next Page](@next)

