using Jaa;
using Gee;


public class Mens :Object {

  public string firstName        {get ; set; default ="";}
  public string lastName         {get ; set; default ="";}

  public Mens (){
    stdout.printf (" #########!!!!!!!!!!!!  \n"); 
  }
  public  void print_obj (){
    stdout.printf ("%s ######> %s  \n",this.firstName,this.lastName ); 
  }
}


public class JHumans : Object  {

	public string firstName         {get ; set; default = ""   ;}
	public string lastName          {get ; set; default = ""   ;}
	public string Name              {get ; set; default = ""   ;}
	public int    age               {get ; set; default = -1   ;}
	public double tall              {get ; set; default = -1.0 ;}
	public bool   live              {get ; set; default = false;}

	public Mens man                 {get ; set;} //construct
	public ArrayList<Mens> mens     {get ; set;}
	public ArrayList<int>?  Numbers {get ; set;}

	public JHumans (){}

	construct{
		this.mens   = new ArrayList <Mens> ();
	}

  public void print_obj (){
    man.print_obj();
    mens.get(0).print_obj();
    mens.get(1).print_obj();
    stdout.printf ("%s => %s ==> %i \n",this.firstName,this.lastName ,this.Numbers.get(1)); 
  }
}


int main () {

	string str = 
		"""[{
			"firstName"  : "Aissat",
			"lastName"   : "Abdou" ,
			"Name"       : "abdelwahab" ,
			"age"        : 26     ,
			"Numbers"    : [90,23,933] ,
			"man"        : {
				"firstName" : "Mohamed",
				"lastName"  : "aissat" 
				},
			"mens"        :
				[
					{ "firstName" : "Marty",
					  "lastName"  : "McFly" },

					{ "firstName" : "Emmett",
					  "lastName"  : "Brown" }
				]
		}]""";

	Json.Parser parser = new Json.Parser ();
	try {
		parser.load_from_data (str);
	} catch (Error e) {
		stdout.printf ("Unable to parse data: %s\n", e.message);
		return -1;
	}

	Json.Node node = parser.get_root ();


	JReaderArrayObject<JHumans> test = new JReaderArrayObject<JHumans>(node);
	stdout.printf ("test age: %i\n", test.get(0).age);
	test.get(0).print_obj();

	//JReaderObject<JHumans> tst = new JReaderObject<JHumans>(node);
	//tst.get_object().print_obj();

return 0;


}
