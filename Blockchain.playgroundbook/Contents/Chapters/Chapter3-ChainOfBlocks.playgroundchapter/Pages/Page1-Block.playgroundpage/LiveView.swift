//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

// Present the view controller in the Live View window

let block = ProxyBlock(value: "This is the value of the block.", previousBlock: nil, previousHash: nil, isChainValid: true)
PlaygroundPage.current.liveView = BlockChainViewController(defaultProxyBlockChain: block)
PlaygroundPage.current.needsIndefiniteExecution = true
