//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

// Present the view controller in the Live View window
let block1 = ProxyBlock(value: "Frederik paid 3 Bitcoin to Larissa.", previousBlock: nil, previousHash: nil, isChainValid: true)
let block2 = ProxyBlock(value: "Larissa paid 999999 Bitcoin to Frederik.", previousBlock: block1, previousHash: nil, isChainValid: true)
let block3 = ProxyBlock(value: "Markus paid 2 Bitcoin to Robbie.", previousBlock: block2, previousHash: nil, isChainValid: false)
PlaygroundPage.current.liveView = BlockChainViewController(defaultProxyBlockChain: block3)
PlaygroundPage.current.needsIndefiniteExecution = true
