
import MySQL
import HTTP



let loader=JSONLoader()

let bands=loader.load()

if let database=Database() {
    //database.saveBands(bands)
    //database.buildRelations()
    database.loadImages()
}




    











