package models
{
	import org.apache.flex.collections.ArrayList;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.EventDispatcher;

	public class TechnoStormModel extends EventDispatcher implements IBeadModel
	{
		
		public var TECHNO_STORM_REGISTER_SERVICE_URL:String = "http://ap-pun-lp1400/CustRegister";
		public var TECHNO_STORM_ADD_TRANSACTION_SERVICE_URL:String = "http://ap-pun-lp1400/PaymentReq";
		public var TECHNO_STORM_TRANSACTION_HISTORY_SERVICE_URL:String = "http://ap-pun-lp1400/PaymentReqStatus";
		
		//public var TECHNO_STORM_REGISTER_SERVICE_URL:String = "http://ap-pun-lp1327:8080/CustRegister";
		//public var TECHNO_STORM_ADD_TRANSACTION_SERVICE_URL:String = "http://ap-pun-lp1327:8080/PaymentReq";
		//public var TECHNO_STORM_TRANSACTION_HISTORY_SERVICE_URL:String = "http://ap-pun-lp1327:8080/PaymentReqStatus";
		
		private var _beneficiaryList:Array = [{label:"-Beneficiary Option-",code:0},{label:"Central",code:"SBI"},
													   {label:"Shoppers Stop",code:"SBH"},{label:"Best But",code:"SBJ"},
													   {label:"WestSide",code:"SBM"},{label:"Big Bazar",code:"SBP"},
													   {label:"Brand Factory",code:"SBT"},{label:"DMart",code:0},
													   {label:"Relience Mart",code:"SLB"}];
		
		public var userId:String;
		
		private var _transactionHistory:ArrayList;
		
		public function TechnoStormModel()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		
		[Bindable]
		public function get beneficiaryList():Array
		{
			return _beneficiaryList;
		}
		
		public function get transactionList():ArrayList
		{
			return _transactionHistory;
		}
		
		public function set transactionList(param:ArrayList):void
		{
			_transactionHistory = param;
		}
	}
}