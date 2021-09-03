//
//  charDetail.swift
//  rickAndMorty
//
//  Created by ธนัท แสงเพิ่ม on 3/9/2564 BE.
//

import SwiftUI

struct charDetail: View {
    
    let charac:result
    
    var body: some View {
        VStack{
            Text(charac.name)
        }.navigationBarTitle(Text(charac.name), displayMode: .inline)
    }
}
//
//struct charDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        charDetail()
//    }
//}
