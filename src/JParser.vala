namespace Jaa {
  public class JParser : Json.Parser{
  	public Json.Node? node { get; private set; }

  	public JParser (string data){
  		try {
  			this.load_from_data (data);
        this.node = this.get_root ();
  		} catch (Error e) {
  			stdout.printf ("Unable to parse data: %s\n", e.message);
  		}

  	}

  	public JParser.from_file (string path){
  		try {
  			this.load_from_file (path);
        this.node = this.get_root ();
  		} catch (Error e) {
  			stdout.printf ("Unable to parse from file ");
  		}

  	}
  }

}
