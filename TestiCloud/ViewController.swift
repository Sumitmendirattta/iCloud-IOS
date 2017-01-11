import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bookName: UITextField!
    @IBOutlet weak var bookAuthor: UITextField!
    @IBOutlet weak var bookDesc: UITextField!
    var detail:String = ""

    var keyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
    
    @IBAction func saveinCloud(_ sender: AnyObject) {
         detail=bookName.text!+" "+bookAuthor.text!+" "+bookDesc.text!
        
        keyStore?.set(detail, forKey: "CloudData")
        keyStore?.synchronize()
        print("detail:",detail)
        loadinCloud()
    }
    
    func loadinCloud(){
        if  let storedString = keyStore?.string(forKey: "CloudData"){
            
            print(storedString)
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if let storedString = keyStore?.string(forKey: "CloudData"){
            let str=storedString.components(separatedBy: " ")
            bookName.text=str[0]
            bookAuthor.text=str[1]
            bookDesc.text=str[2]
            print("storedString:", storedString)
            print(str)
        }
        
        NotificationCenter.default.addObserver(self,
        selector:Selector(("ubiquitousKeyValueStoreDidChangeExternally:")),
        name:  NSUbiquitousKeyValueStore.didChangeExternallyNotification,
        object: keyStore)
    }
    
    func ubiquitousKeyValueStoreDidChangeExternally(notification: NSNotification) {
        
        let alert = UIAlertController(title: "Change detected",
                                      message: "iCloud key-value-store change detected",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true,
                                   completion: nil)
        bookName.text = keyStore?.string(forKey: "CloudData")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

