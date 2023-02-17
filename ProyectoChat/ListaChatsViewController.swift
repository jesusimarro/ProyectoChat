//
//  ListaChatsViewController.swift
//  ProyectoChat
//
//  Created by estech on 8/2/23.
//

import UIKit

class ListaChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contactos = ["Persona 1"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "protocell1", for: indexPath) as! CeldaContactos
        cell.contactoText.text = contactos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
