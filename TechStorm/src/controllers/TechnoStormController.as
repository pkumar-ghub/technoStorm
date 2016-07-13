package controllers
{
	import models.Customer;
	import models.TechnoStormModel;
	
	import org.apache.cordova.Application;
	import org.apache.flex.collections.ArrayList;
	import org.apache.flex.collections.converters.JSONItemConverter;
	import org.apache.flex.collections.parsers.JSONInputParser;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.events.Event;
	import org.apache.flex.net.HTTPHeader;
	import org.apache.flex.net.HTTPService;

	public class TechnoStormController implements IDocument
	{
		private var mobileApp:TechStorm;
		
		public function TechnoStormController(app:Application = null)
		{
			if(app)
			{
				this.mobileApp = app as TechStorm;
				mobileApp.addEventListener("viewChanged", viewChangeHandler);
			}
		}
		
		private function viewChangeHandler(event:Event):void
		{
			(mobileApp.initialView as HomeView).loginViewId.addEventListener("login", loginHandler);
			(mobileApp.initialView as HomeView).loginViewId.addEventListener("register", loginHandler);
			(mobileApp.initialView as HomeView).addEventListener("getTransaction", getTransactionHistory);
			(mobileApp.initialView as HomeView).addEventListener("register", userRegisterHandler);			
		}
		
		private function loginHandler(evt:Event):void
		{
			if(evt.type == "register")
			{
				(mobileApp.initialView as HomeView).currentState = "register";
				(mobileApp.initialView as HomeView).saveIconId.visible = true;
			}
			else
			{
				var username:String = (mobileApp.initialView as HomeView).loginViewId.txtUserId.text;
				var password:String = (mobileApp.initialView as HomeView).loginViewId.txtPasswordId.text;
				
				if((username.toLowerCase() == "technouser" || username.toLowerCase() == "MyUser") && password.toLowerCase() == "app12345")
				{
					(mobileApp.model as TechnoStormModel).userId = username.toLowerCase();
					(mobileApp.initialView as HomeView).listIconId.visible = true;
					(mobileApp.initialView as HomeView).plusIconId.visible = true;
					(mobileApp.initialView as HomeView).currentState = "payment";
					(mobileApp.initialView as HomeView).addTransactionViewId.baneficiaryComboId.dataProvider = (mobileApp.model as TechnoStormModel).beneficiaryList;
					(mobileApp.initialView as HomeView).addTransactionViewId.addEventListener("request", onPaymentRequest);
				}
			}
		}
		
		private function onPaymentRequest(evt:Event):void
		{
			var beneficiary:String = (mobileApp.initialView as HomeView).addTransactionViewId.baneficiaryComboId.selectedItem.label;
			var amount:String = (mobileApp.initialView as HomeView).addTransactionViewId.txtAmtId.text;
			var userId:String = (mobileApp.model as TechnoStormModel).userId;
			
			var service:HTTPService = new HTTPService();
			service.addEventListener("complete", newtransactionHistoryResultHandler);
			service.url = (mobileApp.model as TechnoStormModel).TECHNO_STORM_ADD_TRANSACTION_SERVICE_URL;
			service.method = HTTPService.HTTP_METHOD_POST;
			var header:HTTPHeader = new HTTPHeader("Accept","application/json");
			service.headers = [header];
			service.contentType = "application/json";
			service.contentData = '{"userid":"' + userId + '","beneficiary":"' + beneficiary +'","amount":"' + amount + '"}';
			service.send();			
		}
		
		private function getTransactionHistory(evt:Event):void
		{
			var service:HTTPService = new HTTPService();
			service.addEventListener("complete", transactionHistoryResultHandler);
			service.url = (mobileApp.model as TechnoStormModel).TECHNO_STORM_TRANSACTION_HISTORY_SERVICE_URL + "/" + (mobileApp.model as TechnoStormModel).userId;
			service.send();
		}
		
		private function newtransactionHistoryResultHandler(evt:Event):void
		{
			var tempService:HTTPService = evt.target as HTTPService;
			(mobileApp.initialView as HomeView).addTransactionViewId.transactionGrid.visible = true;
			(mobileApp.initialView as HomeView).addTransactionViewId.transactionGrid.dataProvider = parseTransactionRecords(tempService.data);
		}
		
		private function transactionHistoryResultHandler(evt:Event):void
		{
			var tempService:HTTPService = evt.target as HTTPService;
			(mobileApp.initialView as HomeView).transactionViewId.transactionGrid.dataProvider = parseTransactionRecords(tempService.data);
		}
		
		private function parseTransactionRecords(tranData:String):ArrayList
		{
			var jsonParser:JSONInputParser = new JSONInputParser();
			var jsonDataArray:Array = jsonParser.parseItems(tranData);
			var jsonItemParser:JSONItemConverter = new JSONItemConverter();
			
			var transactionArray:Array = new Array();
			for each(var dataString:String in jsonDataArray)
			{
				var  tempObject:Object = jsonItemParser.convertItem(dataString);
				tempObject.status = (tempObject.status == true ? "APPROVED" : "PENDING");
				transactionArray.push(tempObject);
			}			
			return new ArrayList(transactionArray);
		}
		
		private function userRegisterHandler(evt:Event):void
		{
			var customerVO:Customer = new Customer();
			customerVO.name = (mobileApp.initialView as HomeView).registerViewId.txtNameId.text;
			customerVO.userId = (mobileApp.initialView as HomeView).registerViewId.txtUserId.text;
			customerVO.mobile = (mobileApp.initialView as HomeView).registerViewId.txtMobileId.text;
			customerVO.email = (mobileApp.initialView as HomeView).registerViewId.txtEmailId.text;
			
			
			var service:HTTPService = new HTTPService();
			service.url = (mobileApp.model as TechnoStormModel).TECHNO_STORM_REGISTER_SERVICE_URL;
			service.method = HTTPService.HTTP_METHOD_POST;
			var header:HTTPHeader = new HTTPHeader("Accept","application/json");
			service.headers = [header];
			service.contentType = "application/json";
			service.contentData = customerVO.toJSON;
			service.send();		
		}
		
		public function setDocument(document:Object, id:String = null):void
		{
			this.mobileApp = document as TechStorm;
			mobileApp.addEventListener("viewChanged", viewChangeHandler);
		}
	}
}