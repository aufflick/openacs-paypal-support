ad_library {
    Support code for paypal interaction

    @author Mark Aufflick (mark@pumtheory.com)
    @creation-date 2005-07-31
    @cvs-id $Id$
}

namespace eval paypal {}
namespace eval paypal::ipn {}

ad_proc -public paypal::package_key {} {} { return "paypal-support" }
ad_proc -public paypal::package_id {} {} { return [apm_package_id_from_key [paypal::package_key]] }

ad_proc -public paypal::buy_now {
	-business
	-item_name:required
	-currency_code
	-amount:required
	-callback_impl
	-invoice_id
	-no_shipping:boolean
	-return_url
	{-alt ""}
} {
	Creates an html fragment that implements a buy now link for a paypal item.

	Note that this intentionally does not set the 'notify_url' param since that seems
	to encourage attacks - you need to set a fixed IPN notify url in your paypal
	account admin. Your callback url will be the url that your paypal-support instance is mounted
	(/paypal-support by default) plus /ipn-callback appended.

	@param business override the paypal-support package default

	@return The html fragment
} {
	paypal::apply_package_defaults

	paypal::form::start
	paypal::form::hidden_value "cmd" "_xclick"
	paypal::form::hidden_value "business" "$business"
	paypal::form::hidden_value "item_name" "$item_name"
	paypal::form::hidden_value "currency_code" "$currency_code"
	paypal::form::hidden_value "amount" "$amount"
	if {[exists_and_not_null return_url]} {
		paypal::form::hidden_value "return" "$return_url"
	}
	if {[exists_and_not_null callback_impl]} {
		paypal::form::hidden_value "custom" $callback_impl
	}
	if {[exists_and_not_null invoice_id]} {
		paypal::form::hidden_value "invoice" $invoice_id
	}
	paypal::form::hidden_value "no_shipping" "$no_shipping_p"

	paypal::form::submit_button buy_now $alt
	paypal::form::finish

	return $paypal_form
}

# I intend to commit the two below procs to acs-tcl/tcl/utilities-procs.tcl, but they're here for now

ad_proc -public set_unless_exists { varname value } {
	If the variable does not exist, set it to the value. Either way, return the value of the var.
	
	@see set_unless_set
	@see exists_and_equal
	@see exists_and_not_null

	@author Mark Aufflick (mark@pumptheory.com)
} {
	upvar 1 $varname var
	if {! [info exists var]} {
		set var $value
	}
	return $var
}

ad_proc -public set_unless_set { varname value } {
	If the variable does not exist or is empty, set it to the value. Either way, return the value of the var.

	@see set_unless_exists
	@see exists_and_equal
	@see exists_and_not_null

	@author Mark Aufflick (mark@pumptheory.com)

} {
	upvar 1 $varname var
	if {! [exists_and_not_null var]} {
		set var $value
	}
	return $var
}
