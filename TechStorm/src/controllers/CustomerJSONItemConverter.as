package controllers
{
	import models.Customer;
	
	import org.apache.flex.collections.converters.JSONItemConverter;

	public class CustomerJSONItemConverter extends JSONItemConverter
	{
		public function CustomerJSONItemConverter()
		{
			super();
		}
		
		override public function convertItem(data:String):Object
		{
			var obj:Object = super.convertItem(data);
			var customer:Customer = new Customer();
			for(var key:String in obj)
			{
				customer[key] = obj[key];
			}
			return customer;
		}
	}
}