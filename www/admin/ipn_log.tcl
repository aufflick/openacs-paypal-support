ad_page_contract {

  @author mark@pumptheory.com
  @creation-date 2005-08-04
  @cvs-id $Id$
} {
}

set context "PayPal IPN log"
set title "PayPal IPN log"

template::list::create \
	-name ipn_log \
	-multirow ipn_log \
	-key ipn_log_id \
	-elements {
		ipn_verified {
			label "IPN Verified"
		}
		business {
			label "PayPal Business Email"
		}
		item_name {
			label "Item Name"
		}
		currency_code {
			label "Currency"
		}
		amount {
			label "Amount"
		}
		payment_status {
			label "Payment Status"
		}
		payment_type {
			label "Payment type"
		}
		quantity {
			label "Qty"
		}
		payer_status {
			label "Payer Status"
		}
		callback {
			label "TCL Callback"
		}
		callback_response {
			label "TCL Callback Response"
		}
		tax {
			label "Tax"
		}
		shipping {
			label "Shipping"
		}
		invoice {
			label "Invoice"
		}
		payment_date {
			label "Payment Date"
		}
		first_name {
			label "First name"
		}
		last_name {
			label "Last name"
		}
		test_ipn {
			label "PayPal Sandbox"
		}
		payer_email {
			label "Payer email"
		}
		receiver_email {
			label "Receiver email"
		}
		memo {
			label "Memo"
		}
	}

db_multirow -extend url ipn_log ipn_log {
	select *
	from paypal_ipn_log
} {
	set url [export_vars -url -base "ipn_log_detail" {ipn_log_id}]
}
ad_return_template
