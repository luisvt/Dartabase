import "dart:io";
import "dart:async";
import "dartabase.dart";

void main() {
  print("|--------------------------|");
  print("|     Create migration     |");
  print("|--------------------------|");
  print("");
  print("Enter the project name and press the ENTER key to proceed");

  projectMapping = DBHelper.jsonFilePathToMap("projectsMapping.json");
  
  print("\nProject name *:* Path *:* Current schema version");
  print("-----------------------------");
  Map schemaV;
  for(var name in projectMapping.keys){
    schemaV = DBHelper.jsonFilePathToMap("${projectMapping[name]}/db/schemaVersion.json");
    print("$name *:* ${projectMapping[name]} *:* ${schemaV['schemaVersion']}");
    
  }
  Stream<List<int>> stream = stdin;
  
  stream
      .transform(new StringDecoder())
      .transform(new LineTransformer())
      .listen((String line) { /* Do something with line. */
        if(rootPath != null){
          Map migration = {
              "UP": {
                "createTable": {
                  "new_table_name": {
                    "new_column_name": "DATATYPE"
                  }
                },
                "createColumn": {
                  "existing_table_name": {
                    "new_column_name": "DATATYPE"
                  }
                },
                "removeColumn": {
                  "existing_table_name": ["existing_column_name"]
                },
                "removeTable": ["existing_table_name"]
              },
            "DOWN": {}
          };
          DateTime dT = new DateTime.now();
          
           
          var month = "${dT.month}".length == 1 ? "0${dT.month}" : "${dT.month}";
          var day = "${dT.day}".length == 1 ? "0${dT.day}" : "${dT.day}";
          var hour = "${dT.hour}".length == 1 ? "0${dT.hour}" : "${dT.hour}";
          var minute = "${dT.minute}".length == 1 ? "0${dT.minute}" : "${dT.minute}";
          var second = "${dT.second}".length == 1 ? "0${dT.second}" : "${dT.second}";
          String dateTime = "${dT.year}$month$day$hour$minute$second";
          DBHelper.mapToJsonFilePath(migration, "$rootPath/db/migrations/${dateTime}_$line.json");
          print("migration $rootPath/db/migrations/${dateTime}_$line.json created");
        }else if(projectMapping[line] != null){
          rootPath = projectMapping[line];
          print("please enter migration name eg. create_table_player");
        }else{
          print("Project '$line' dosn't exist");
        }
   
            
        
      },
      onDone: () { /* No more lines */ 
        print("Dartabase migration created!");
      },
     onError: (e) { /* Error on input. */ 
       print("Dartabase migration error! $e");
     });
}