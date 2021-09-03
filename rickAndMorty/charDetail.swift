//
//  charDetail.swift
//  rickAndMorty
//
//  Created by ธนัท แสงเพิ่ม on 3/9/2564 BE.
//

import SwiftUI

extension String{
    func load() -> UIImage{
        do{
            guard let url = URL(string:self)else{
                return UIImage() //empty image
            }
            let data:Data = try Data(contentsOf: url)
            return UIImage(data:data) ?? UIImage()
        }catch{
            return UIImage()
        }
    }
}

struct charDetail: View {
    
    let charac:result
    
//    let layout = [
//        GridItem(.adaptive(minimum: 50))
//    ]
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Image(uiImage:charac.image.load())
            HStack{
                Text("NAME : ")
                Text(charac.name).bold()
            }
            HStack{
                Text("STATUS : ")
                Text(charac.status).bold()
            }
            HStack{
                Text("SPECIES : ")
                Text(charac.species).bold()
            }
            if charac.type != ""{
                HStack{
                    Text("TYPE : ")
                    Text(charac.type).bold()
                }
            }
            HStack{
                Text("GENDER : ")
                Text(charac.gender).bold()
            }
            HStack{
                Text("ORIGIN : ")
                Text(charac.origin.name).bold()
            }
            HStack{
                Text("LOCATION : ")
                Text(charac.location.name).bold()
            }
            Text("FOUND IN EPISODE :")
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], content: {
                    ForEach(charac.episode, id: \.self){ep in
                        let onlyEp = ep.split{$0 == "/"}
                        Text(onlyEp[4])
                            .padding()
                    }
                })
            }
        }.navigationBarTitle(Text(charac.name), displayMode: .inline)
    }
}
//
//struct charDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        charDetail()
//    }
//}
