import UIKit
extension String {
    public func shaHash() -> String {
        return self.sha256()
    }
}
