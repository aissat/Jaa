using Gee;

namespace Jaa {

	public class JReaderObject<T> : Object {
		public Json.Node   JNode   {get ; set;}

		private Json.Reader JReader ;
		private Json.Object JObject ;

		private Object? _object;
		private ObjectClass ocl ;

		public JReaderObject (Json.Node   node=this.JNode ){

			Type type              = typeof(T);
			_object                = Object.new(type);

			this.ocl = (ObjectClass) type.class_ref ();

			this.JNode        = node;
			this.JObject      = this.JNode.get_object ();
			add_object(_object,JObject);

			this.JReader      = new Json.Reader (this.JNode);

		}

		public T get_object(){
			return _object;
		}

		private Object add_object(Object?  Ob,Json.Object O ){

			foreach ( var item in O.get_members()){

				switch(O.get_member(item).type_name()){
				case "String":
					Ob.set(item,O.get_string_member(item),null); 
					break;

					case "Integer":
						Ob.set(item,(int)O.get_int_member(item),null);
						break;

					case "Floating Point":
						Ob.set(item,O.get_double_member(item),null);
						break;

					case "Boolean":
						Ob.set(item,O.get_boolean_member(item),null);
						break;

					case "JsonObject":
						unowned ParamSpec? spec = ocl.find_property (item); 
						Object? ob = Object.new(spec.value_type);
						Ob.set (item, add_object (ob,O.get_member ((string)item).get_object () ) );
						break;

					case "JsonArray":
						Ob.set( item, add_elements (O.get_member ((string)item), item) , null) ;
						break;
				}
			}
			return Ob;

		}

		private ArrayList add_elements(Json.Node node ,string key = ""){

			Json.Reader reader = new Json.Reader (node);
			Json.Array JArray  = node.get_array();
			Json.Object JObject ;

				switch(JArray.get_element (0).type_name () ){
					case "String":
						var array = new ArrayList<string> ();
						for(int i= 0; i<reader.count_elements (); i++){
							reader.read_element (i);
							assert (reader.is_value ());
							array.add((string)reader.get_string_value ());
							reader.end_element ();
						}
						return array;

					case "Integer":
						var array = new ArrayList<int>();
						for(int i= 0; i<reader.count_elements (); i++){
							reader.read_element (i);
							assert (reader.is_value ());
							array.add((int)reader.get_int_value ());
							reader.end_element ();
						}
						return array;

					case "Floating Point":
						var array = new ArrayList<double?> ();
						for(int i= 0; i<reader.count_elements (); i++){
							reader.read_element (i);
							assert (reader.is_value ());
							array.add(reader.get_double_value ());
							reader.end_element ();
						}
						return array;

					case "Boolean":
						var array = new ArrayList<bool> ();
						for(int i= 0; i<reader.count_elements (); i++){
							reader.read_element (i);
							assert (reader.is_value ());
							array.add(reader.get_boolean_value ());
							reader.end_element ();
						}
						return array;

					case "JsonObject":
						unowned ParamSpec? spec = ocl.find_property (key); 
						Type fieldType          = spec.value_type;
						Value obj               = Value( fieldType );
						_object.get_property(key, ref obj);

						Gee.ArrayList<Object?> array = (Gee.ArrayList) obj.get_object();
						if(obj.holds (typeof (Gee.Iterable) ) ){
							if (node.get_node_type () == Json.NodeType.ARRAY) 
							foreach ( Json.Node iter in JArray.get_elements ()){
								Object? ob = Object.new( array.element_type);
								JObject      = iter.get_object ();
								array.add (add_object (ob,JObject ) );
							}
						}
						return array;
				}

			return (ArrayList)null;

		}

	}

}
