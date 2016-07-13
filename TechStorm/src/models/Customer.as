package models
{
	public class Customer
	{
		public var userId:String;
		public var name:String;
		public var mobile:String;
		public var email:String
		
		public function get toJSON():String
		{
			var tempString:String = "{";
			tempString += '"userid":"' + userId + '"';
			tempString += ',"name":"' + name + '"';
			tempString += ',"mobile":"' + mobile + '"';
			tempString += ',"email":"' + email + '"';
			
			tempString += "}";
			return tempString;
		}
	}
}