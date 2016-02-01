public with sharing class NestedMapController {

    public Map<String, Map<String, myObject>> objectMap {get; set;}
    public List<String> ListofString1Entries {get; set;}
    public List<String> ListofString2Entries {get; set;}

    public class myObject {
        public String Name { get; set; }
        public String Division { get; set; }

        public myObject(String name, String division) {
            this.Name = name;
            this.Division = division;
        }
    }

    public NestedMapController() {
        // build the string lists
        ListofString1Entries = 'String1-Key1,String1-Key2'.split(',');
        ListofString2Entries = 'String2-Key1,String2-Key2'.split(',');

        // build the map data
        objectMap = new Map<String, Map<String, myObject>>();
        objectMap.put('String1-Key1', new Map<String, myObject>{'String2-Key1' => new myObject('Name1', 'Division1'), 
                                                             'String2-Key2' => new myObject('Name2', 'Division2')});

        objectMap.put('String1-Key2', new Map<String, myObject>{'String2-Key1' => new myObject('Name3', 'Division3'), 
                                                             'String2-Key2' => new myObject('Name4', 'Division4')});

    }
}