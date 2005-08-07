ad_library {
    Support code for paypal interaction

    @author Mark Aufflick (mark@pumtheory.com)
    @creation-date 2005-07-31
    @cvs-id $Id$
}

namespace eval paypal {}
namespace eval paypal::ipn {}

ad_proc -private paypal::ipn::callback_name {} {} { return "paypal::ipn::callback" }

ad_proc -private paypal::ipn::handle_ipn {
	-form:required
} {} {
	# log all values in the server log
	for {set i 0} {$i < [ns_set size $form]} {incr i} {
		set key [ns_set key $form $i]
		set value [ns_set value $form $i]
		ns_log Notice "PayPal IPN: $key=$value"
	}

	# log the ipn data in our log table
	foreach ipn_field_name {txn_id business item_name mc_currency custom tax shipping
			  invoice payment_date first_name last_name payment_type quantity
			  payer_status test_ipn payer_email receiver_email memo mc_gross
			  payment_status ipn_qs} {
		set $ipn_field_name [ns_set get $form $ipn_field_name]
	}

	set ipn_log_id [db_nextval paypal_ipn_log_seq]

	# if we have recieved a duplicate txn_id from paypal (Paypal will retry an IPN
	# under some circumstances - I think it's if we don't return a 200 to their
	# post - this will kit the txn_id unique key here and be rejected, but what
	# we *should* do is log the duplicate attempt, and take no action (ie. don't
	# make the tcl callback)
	
	db_dml log_ipn_form {
		insert into paypal_ipn_log
		     (ipn_log_id, txn_id,
			  business, item_name, currency_code, amount, callback, tax, shipping,
			  invoice, payment_date, first_name, last_name, payment_type, quantity,
			  payer_status, test_ipn, payer_email, receiver_email, memo,
			  payment_status, ipn_qs)
		values
		     (:ipn_log_id, :txn_id,
			  :business, :item_name, :mc_currency, :mc_gross, :custom, :tax, :shipping,
			  :invoice, :payment_date, :first_name, :last_name, :payment_type, :quantity,
			  :payer_status, :test_ipn, :payer_email, :receiver_email, :memo,
			  :payment_status, :ipn_qs)
	}

	set ipn_set [ns_set copy [ns_conn form]]

	set qsset [ns_set copy [ns_conn form]]
	ns_set put $qsset cmd "_notify-validate"

	set webscr [paypal::webscr_url]
	if {[regexp {^https} $webscr]} {
		set result [ns_httpspost $webscr "" $qsset]
	} else {
		set result [ns_httppost $webscr "" $qsset]
	}

	# log result and call acs callback
	
	if {[regexp {^VERIFIED$} $result]} {
		ns_log Notice "PayPal IPN: result confirmed ('$result')"
		db_dml set_ipn_verified_true {update paypal_ipn_log set ipn_verified = 't' where ipn_log_id = :ipn_log_id}
		# call tcl callback
		if {$custom ne "" && [callback::impl_exists -callback [paypal::ipn::callback_name] -impl $custom]} {
			ns_log Notice "PayPal IPN: Calling callback [paypal::ipn::callback_name] -impl $custom"
			set callback_result [callback -impl $custom [paypal::ipn::callback_name] -ipn_ns_set $ipn_set]
			ns_log Notice "PayPal IPN: callback implementation returned: $callback_result"
		}		
	} else {
		ns_log Notice "PayPal IPN: result rejected ('$result')"
		db_dml set_ipn_verified_false {update paypal_ipn_log set ipn_verified = 'f' where ipn_log_id = :ipn_log_id}
	}

}
