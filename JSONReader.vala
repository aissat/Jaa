using Gee;

namespace Gson {
	public class JSONReader : Object {

		private Json.Parser parser ;
		private Json.Node   node   ;
		private Json.Reader reader ;
		private Json.Object object ;


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
								var arr = new ArrayList<string>();
								add_string_elements_array(key,arr);
								break;

							case JVal.Bool:
								var arr = new ArrayList<bool>();
								add_bool_elements_array(key,arr);
								break;

							case JVal.Null:
								break;

							case JVal.Int:
								var arr = new ArrayList<int>();
								add_int_elements_array(key,arr);
								break;

							case JVal.Double:
								var arr = new ArrayList<double?>();
								add_double_elements_array(key,arr);
								break;

							case JVal.Object:
								Object?  Ob =args.arg();
								var arr = new ArrayList<Object?>();

								this.object = this.node.get_object ();
								Json.Array A = this.object.get_array_member (key);

								this.set(key, add_object_elements_array (A, Ob, arr), null);
								break;

							}
						}
						break;

					case JVal.Object:
						assert (this.reader.is_object ());
						Object?  Ob =args.arg();
						this.object = this.node.get_object ();
						Json.Object O = this.object.get_object_member(key);
						this.set(key,add_object(Ob,O),null);
						break;

					default:
					assert_not_reached ();
				}
				reader.end_member ();
			}

		Object add_object (Object?  Ob, Json.Object O ){

			foreach ( var item in O.get_members()){

				switch(O.get_member (item).type_name ()){

				case "String":
					Ob.set(item,O. get_string_member (item), null);
					break;

					case "Integer": // I'm casting  O.get_int_member (item) to Int from Int64
						Ob.set(item, (int)O.get_int_member (item), null);
						break;

					case "Floating Point":
						Ob.set(item, O.get_double_member (item), null);
						break;

					case "Boolean":
						Ob.set(item, O.get_boolean_member (item), null);
						break;

				}
			}

			return Ob;
		}

		ArrayList add_object_elements_array(Json.Array A, Object?  Ob, ArrayList<Object?> array){
			var type = Ob.get_type();
			foreach ( Json.Node iter in A.get_elements ()){
				var Obj = add_object(Object.new(type),iter.get_object());
				array.add( Obj );
			}
			return array;
		}

		void add_string_elements_array(string key, ArrayList<string?> array){
			for(int i= 0; i<=this.reader.count_elements (); i++){
				this.reader.read_element (i);
				assert (this.reader.is_value ());
				array.add(this.reader.get_string_value ());
				this.reader.end_element ();
			}
			this.set(key,array,null);
		}

		void add_bool_elements_array(string key, ArrayList<bool?> array){
				for(int i= 0; i<=this.reader.count_elements (); i++){
				this.reader.read_element (i);
				assert (this.reader.is_value ());
				array.add(this.reader.get_boolean_value ());
				this.reader.end_element ();
			}
			this.set(key,array,null);
		}

		void add_double_elements_array(string key, ArrayList<double?> array){
				for(int i= 0; i<=this.reader.count_elements (); i++){
				this.reader.read_element (i);
				assert (this.reader.is_value ());
				array.add(this.reader.get_double_value ());
				this.reader.end_element ();
			}
			this.set(key,array,null);
		}

		void add_int_elements_array(string key, ArrayList<int> array){
				for(int i= 0; i<=this.reader.count_elements (); i++){
				this.reader.read_element (i);
				assert (this.reader.is_value ());
				array.add((int)this.reader.get_int_value ());
				this.reader.end_element ();
			}
			this.set(key,array,null);
		}
	}
}
