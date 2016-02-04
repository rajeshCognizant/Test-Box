public class A{
public string ak{get;set;}
public List<string> ak2{get;set;}
public A(){
ak ='1;2;3;4;5;6;7;8;9;';
ak2 = new List<string>();
ak2 =ak.split(';');
ak2.add('10');
ak2.add('20');
ak2.add('30');
ak2.add('40');
ak2.add('50');
//comment
}
}