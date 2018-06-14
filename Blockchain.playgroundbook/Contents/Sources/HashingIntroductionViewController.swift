import UIKit
import PlaygroundSupport

public class HashingIntroductionViewController : UIViewController, PlaygroundLiveViewMessageHandler {
    
    public let originalText = UILabel()
    public let imageView = UIImageView()
    public let hashLabel = UILabel()
    
    public override func viewDidLoad() {
        view.backgroundColor = .black
        
        
        originalText.translatesAutoresizingMaskIntoConstraints = false
        originalText.text = "This is a normal text string."
        originalText.textColor = .white
        originalText.numberOfLines = -1
        originalText.font = UIFont.systemFont(ofSize: 22)
        originalText.textAlignment = .center
        
        imageView.image = UIImage(named: "arrow")
        imageView.contentMode = .scaleAspectFit
        
        
        hashLabel.translatesAutoresizingMaskIntoConstraints = false
        hashLabel.text = "e48770529d44c22ff5eb07925e3851586e4d90753ebdd8e01e4db97bba3d304f"
        hashLabel.textColor = .white
        hashLabel.numberOfLines = -1
        hashLabel.font = UIFont(name: "Menlo", size: 22)
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical;
        stackView.distribution = .equalSpacing;
        stackView.alignment = .center;
        stackView.spacing = 30;
        stackView.addArrangedSubview(originalText)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(hashLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        
        let widthConstraint = NSLayoutConstraint(item: originalText, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        let widthConstraintImage = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal,
                                                          toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        let widthConstraintHashLabel = NSLayoutConstraint(item: hashLabel, attribute: .width, relatedBy: .equal,
                                                          toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        
        
        let xConstraint = NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([widthConstraint, xConstraint, yConstraint, widthConstraintHashLabel, widthConstraintImage])
    }
    
    public func receive(_ message: PlaygroundValue) {
        
        guard case let .dictionary(dict) = message else {return}
        if case let .string(string)? = dict["textString"] {
            originalText.text = string
        }
        if case let .string(string)? = dict["hashString"] {
            hashLabel.text = string
        }
    }
}
