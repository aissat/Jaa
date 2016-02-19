using Gee;

namespace Gson {
	public class JSONReader : Object {

		private Json.Parser parser ;
		private Json.Node   node   ;
		private Json.Reader reader ;


		public  string  data    {get ; set; default ="";}


		public JSONReader (string data,string firstKey, ...){
			this.parser    = new Json.Parser ();
			this.data      = data;
			try {
				this.parser.load_from_data (this.data);
				//print(this.data);
			} catch (Error e) {
				stdout.printf ("Unable to parse data: %s\n", e.message);
			}

			this.node   = this.parser.get_root ();
			this.reader = new Json.Reader (node);

		
			var args         = va_list();
			var firstKeyUsed = false;


			while(firstKey!=null){
				string? key = null;

				if (firstKeyUsed) {
					key = args.arg();
				} else {
					key = firstKey;
					firstKeyUsed = true;
				}

				if (key == null) {
					break; // end of the list
				}


				JVal type = args.arg();
				bool tmp = reader.read_member (key);

				assert (tmp == true);

				switch (type) {

					case JVal.String:
						string val =reader.get_string_value();
						this.set(key,val,null);
						break;

					case JVal.Bool:
						bool val = reader.get_boolean_value();
						this.set(key,val,null);
						break;

					case JVal.Null:
						break;

					case JVal.Int:
						int val = (int)reader.get_int_value();
						this.set(key,val,null);
						break;

					case JVal.Double:
						double val = reader.get_double_value();
						this.set(key,val,null);
						break;

					case JVal.Array:
						assert (this.reader.is_array ());
						JVal arrayType = args.arg();
						if (this.reader.count_elements ()>0){
							switch (arrayType) {

								case JVal.String:
									break;

								case JVal.Bool:

									break;

								case JVal.Null:
									break;

								case JVal.Int:
									break;

								case JVal.Double:
									break;

								case JVal.Object:
									break;
								}
							}
						break;

					case JVal.Object:

					default:
					assert_not_reached ();
				}
				reader.end_member ();
			}
		}
	}
}
