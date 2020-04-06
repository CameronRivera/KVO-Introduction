import UIKit

// KVO - Key-value observing

// KVO is a part of the observer pattern
// NotificationCenter is also an observer pattern

// KVO is a one-to-many pattern relationship as opposed to delegation which is a one-to-one relationship.

// In the delegation pattern
// class ViewController: UIViewController {}
// e.g. tableView.dataSource = self

// KVO is an Objective-C runtime API
// Along with KVO being an objective-c runtime some essentials are required.
// 1. The object being observed needs to be a class
// 2. The class needs to inherit from NSObject. NSObject is the top abstract class in Objective-C. The class must also be marked @objc.
// 3. Any property being marked for observation needs to be prefixed with @objc dynamic. Marking a variable as dynamic means the property is being dynamically dispatched. What this means is that at runtime the compiler verifies the underlying property).
// In Swift, types are statically dispatched. This means they are check at the time of compilation. However, in Objective-C, types are checked at runtime, which is called dynamic.

// Static vs dynamic dispatch
// https://medium.com/flawless-app-stories/static-vs-dynamic-dispatch-in-swift-a-decisive-choice-cece1e872d

// Remeber that the observer pattern works with a subject and one or many observers. In this example, the dog is the subject. The Groomer and the walker are the observers.

// Dog Class (class being observed) - will have a property to be observed.
@objc class Dog: NSObject { // Dog is KVO Compliant
    var name: String
    @objc dynamic var age: Int // age is an observable property - meaning we can now listen for changes.
    init(_ name: String, _ age: Int){
        self.name = name
        self.age = age
    }
}

// Observer Class one
class DogWalker { // Class ViewController2
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? // A handle for the property being observed. i.e. the age property of dog.
    // An observation can be removed(?). Just like a firebase listener.
    // e.g. listenerRegistration is of type ListenerRegistration?
    init(_ dog: Dog){
        self.dog = dog
        configureBirthdayObservation() // If this was a view controller, you would do this in the viewDidLoad, or the initializer if your view controller has one.
    }
    
    private func configureBirthdayObservation(){
        // \.age is keyPath syntax for KVO
        // The change value in the closure gives us access to the values that are in the options.
        birthdayObservation = dog.observe(\.age, options: [.old,.new], changeHandler: { (dog, change) in
            // Update UI accordingly if in a ViewController class
            // Keep in mind that you can do things like reloading a tableview here if that is what you need.
            // oldValue e.g. 5 (if 5 gets incremented by one, new value will be 6)
            // newValue e.g. 6
            guard let age = change.newValue else { return }
            print("Hey \(self.dog.name), happy \(age) birthday from the dog walker.")
            print("dogWalker: Old value is \(change.oldValue ?? 0)")
            print("dogWalker: New value is \(change.newValue ?? 0)")
        })
    }
}

// Observer Class two
class DogGroomer{ // Class ViewController2
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation?
    
    init(_ dog: Dog){
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        birthdayObservation = dog.observe(\.age, options: [.old,.new], changeHandler: { (Dog, change) in
            guard let age = change.newValue else {return}
            // Unwrap the newValue property on change as it is optional.
            print("Hey \(self.dog.name), happy \(age) birthday from the dog groomer.")
            print("groomer oldValue: \(change.oldValue ?? 0)")
            print("groomer newValue: \(change.newValue ?? 0) \n")
        })
    }
}

// test out KVO observing on the .age porperty of Dog.
// both classes (DogWalker and DogGroomer should get .age changes)

let snoopy = Dog("Snoopy", 5)
let dogWalker = DogWalker(snoopy) // both DogWalker and DogGroomer have a reference to snoopy.
let dogGroomer = DogGroomer(snoopy)

snoopy.age += 1 // increment from 5 to 6


