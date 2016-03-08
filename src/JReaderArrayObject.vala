using Gee;

namespace Jaa {
	public class JReaderArrayObject <T> : ArrayList <T> {

		private JReaderObject<T> _object ;

		public JReaderArrayObject (Json.Node   node ){
			if (node.get_node_type () == Json.NodeType.ARRAY){
				Json.Array JArray = node.get_array();
				foreach ( Json.Node iter in JArray.get_elements ()){
					if(iter.get_node_type () == Json.NodeType.OBJECT )
						_object = new JReaderObject<T>(iter);
						this.add(_object.get_object());
				}
			}
		}
	}

}
