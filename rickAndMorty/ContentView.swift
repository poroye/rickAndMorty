//
//  ContentView.swift
//  rickAndMorty
//
//  Created by ธนัท แสงเพิ่ม on 3/9/2564 BE.
//

import SwiftUI

struct characterList:Hashable, Codable{
    let results:[result]
}

struct result:Hashable, Codable{
    let name:String
    let status:String
    let species:String
    let type:String
    let gender:String
    let origin:originStr
    let location:location
    let image:String
    let episode:[String]
}

struct originStr:Hashable, Codable{
    let name:String
}

struct location:Hashable, Codable{
    let name:String
}

class ViewModel:ObservableObject{
    
    @Published var resp:characterList = characterList(results:[])
    
    var page:Int = 1
    
    @Published var tableOn:Bool = false
    
    func fetch(){
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(String(page))") else{return}
        let task = URLSession.shared.dataTask(with: url){
            data, res, err in
            guard let data = data , err == nil else {return}
            do{
                let chars = try JSONDecoder().decode(characterList.self, from: data)
                DispatchQueue.main.async {
                    self.resp = chars
                }
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
    
    
    func back(){
        if viewModel.page > 1{
            viewModel.page -= 1
            print("<")
                viewModel.fetch()
        }else{
            print("can't go left any more")
        }
    }
    
    func next(){
        if viewModel.page < 34{
            viewModel.page += 1
            print(">")
            viewModel.fetch()
        }else{
            print("can't go right any more")
        }
    }
    
    func tabOnOff(){
        viewModel.tableOn.toggle()
        print("toggle")
    }
    
    
    
    var body: some View {
        
        
        if viewModel.tableOn == false{
            NavigationView{
                List{
                    ForEach(viewModel.resp.results, id:\.self){
                        ch in
                        NavigationLink(
                            destination: charDetail(charac:ch),
                            label: {
                                Text("\(ch.name)").bold()
                            }
                        )
                    }
                }
                    .navigationTitle("rick and morty list")
                    .onAppear(perform: viewModel.fetch)
            }
        }else{
            NavigationView{
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], content: {
                            ForEach(viewModel.resp.results, id: \.self){ch in
                                NavigationLink(
                                    destination: charDetail(charac:ch),
                                    label: {
                                        VStack{
                                            Image(uiImage:ch.image.load())
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                            Text(ch.name)
                                        }
                                    }
                                )
                            }
                        }
                    )
                }
                .navigationTitle("rick and morty table")
            }
        }
        HStack{
            Spacer()
            if viewModel.page > 1{
                Button("<",action: back).padding(20).font(.title)
            }else{
                Button("<",action: back).padding(20)
            }
            Spacer()
            if viewModel.tableOn{
                Button("list",action:tabOnOff).font(.title)
            }else{
                Button("table",action:tabOnOff).font(.title)
            }
            Spacer()
            if viewModel.page < 34{
                Button(">",action: next).padding(20).font(.title)
            }else{
                Button(">",action: next).padding(20)
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
