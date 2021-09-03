//
//  ContentView.swift
//  rickAndMorty
//
//  Created by ธนัท แสงเพิ่ม on 3/9/2564 BE.
//

import SwiftUI

struct characterList:Hashable, Codable{
    let info:information
    let results:[result]
}

struct result:Hashable, Codable{
    let name:String
}

struct information:Hashable, Codable{
    let count:Int
    let pages:Int
}

class ViewModel:ObservableObject{
    
    @Published var resp:characterList = characterList(info:information(count:0,pages:0),results:[])
    
    func fetch(){
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=1") else{return}
        let task = URLSession.shared.dataTask(with: url){
            data, res, err in
            guard let data = data , err == nil else {return}
            do{
                let chars = try JSONDecoder().decode(characterList.self, from: data)
                DispatchQueue.main.async {
                    self.resp = chars
                }
                print("\(chars.info.count) \(chars.results[0].name)")
                
            }catch{
                print(error)
            }
            print("fetched!")
            
        }
        task.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
//        Text("Hello, world!")
//            .padding()
        NavigationView{
            List{
                ForEach(viewModel.resp.results, id:\.self){
                    ch in
                    NavigationLink(
                        destination: charDetail(charac:ch),
                        label: {
                            HStack{
                                Text("\(ch.name)").bold()
                            }.padding(3)
                        })
//                    HStack{
//                        Text("\(ch.name)").bold()
//                    }.padding(3)
                }
            }
                .navigationTitle("character rick")
                .onAppear(perform: viewModel.fetch)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
