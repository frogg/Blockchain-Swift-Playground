//: # Concluding Hashing
//: The previous page showed that the `.shaHash()` function generates a hexadecimal string that is unique for every unique object – and equal objects create equal hashes. When executing your code, the result of each line is shown on the right side next to it (tap on it to see more).
"Frederik".shaHash() == "Frederik".shaHash()

//: Changing one object slightly will result in a completely different hash.
/*#-editable-code*/"frederik"/*#-end-editable-code*/.shaHash() == /*#-editable-code*/"Frederik"/*#-end-editable-code*/.shaHash()

//: [Next Page](@next)
