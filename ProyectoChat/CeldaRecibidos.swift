//
//  CeldaRecibidos.swift
//  ProyectoChat
//
//  Created by estech on 10/2/23.
//

import UIKit

class CeldaRecibidos: UITableViewCell {

    @IBOutlet weak var textoRecibido: UILabel!
    @IBOutlet weak var viewRecibido: UIView!
    @IBOutlet weak var imgRecibido: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewRecibido.layer.cornerRadius = 20
        
        imgRecibido.layer.borderWidth = 1
        imgRecibido.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
