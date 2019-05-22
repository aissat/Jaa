# Jaa
Vala  samrt Json lib 

## example

```vala

using Jaa;
using Gee;

public class Mens :Object {

  public string firstName        {get ; set; default ="";}
  public string lastName         {get ; set; default ="";}
  public int    age              {get ; set; default = -1;}

  public Mens (){
    stdout.printf (" #########!!!!!!!!!!!!  \n");
  }
  public  void print_obj (){
    stdout.printf ("%s ######> %s ######> %i \n",this.firstName,this.lastName, this.age );
  }
}


public class JHumans : Object  {

	public string firstName         {get ; set; default = ""   ;}
	public string lastName          {get ; set; default = ""   ;}
	public string Name              {get ; set; default = ""   ;}
	public int    age               {get ; set; default = -1   ;}
	public double tall              {get ; set; default = -1.0 ;}
	public bool   married           {get ; set; default = false;}

	public Mens man                 {get ; set;} //construct
	public ArrayList<Mens> mens     {get ; set;}
	public ArrayList<int>  Numbers  {get ; set;}
	public ArrayList<string> Labels {get ; set;}

	public JHumans (){}

	construct{
		this.mens   = new ArrayList <Mens> ();
	}

  public void print_obj (){
    man.print_obj();

    mens.get(0).print_obj();
    mens.get(1).print_obj();
    stdout.printf ("%s => %s ==> %i : %s ## %.2f ## %s  \n",this.firstName,this.lastName ,
    										this.Numbers.get(1),this.Labels.get(1),
    										this.tall,this.married.to_string () );
  }
}

/**
 *
 */
public class Ones : GLib.Object {

  /**
   *
   */

  public JHumans Human     {get ;  set;}
  construct{
 		this.Human   = new JHumans  ();
 	}
  public Ones () {
    Human.print_obj();
    stdout.printf ("test age: %i\n", this.Human.age);
  }


}

int main () {

string str = """
	[
    {
      "Human":{
			"firstName"  : "Aissat",
			"lastName"   : "Abdou" ,
			"Name"       : "abdelwahab" ,
			"age"        : 26     ,
			"tall"       : 1.90  ,
			"married"    : true  ,
			"Numbers"    : [90,23,933] ,
			"Labels"     : ["foo","bar"],
			"man"        : {
				"firstName" : "Mohamed",
				"lastName"  : "aissat" ,
				"age"       : 29
				},
			"mens"        :
				[
					{ "firstName" : "Ali",
					  "lastName"  : "Ahmed",
					  "age"        : 26
					   },
					{ "firstName" : "Omar",
					  "lastName"  : "hani" ,
					  "age"        : 29
					}
				]
      }
		}
  ]""";

	JParser p = new JParser (str);

  JReaderArrayObject<Ones> test = new JReaderArrayObject<Ones>(p.node);
	stdout.printf ("test age: %i\n", test.get(0).Human.age);
	test.get(0).Human.print_obj();

	//JReaderObject<JHumans> tst = new JReaderObject<JHumans>(node);
	//tst.get_object().print_obj();

return 0;


}
```
