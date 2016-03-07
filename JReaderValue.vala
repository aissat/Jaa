namespace Jaa {

	public class JReaderValue <T> : Object {

		private Value    _value ;

		public JReaderValue (Json.Node   node ){

			if (node.get_node_type () == Json.NodeType.ARRAY){
				_value = Value(typeof(JArrayReaderObject));
				_value = new JArrayReaderObject<JHumans>(node);
			}else {
				_value = Value(typeof(JReaderObject));
				_value = new JReaderObject<T>(node);
			}
		}

		public T get_object(){
			return _value.get_object();
		}

		public ArrayList? get_array(){
			return (ArrayList)_value.get_object();
		}

		public Value get_value(){
			return _value;
		}

	}
}
