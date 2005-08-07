ad_library {
    Support code for paypal interaction

    @author Mark Aufflick (mark@pumtheory.com)
    @creation-date 2005-07-31
    @cvs-id $Id$
}

namespace eval paypal {}
namespace eval paypal::form {}

ad_proc -private paypal::form::submit_button {
	type
	{alt ""}
} {} {
	upvar paypal_form paypal_form
	set src [ad_parameter -package_id [paypal::package_id] "PaypalButtonImage_buy_now"]
	append paypal_form "<input type=\"image\" src=\"$src\" name=\"submit\" alt=\"$alt\">\n"
}


ad_proc -private paypal::webscr_url {} {} {
	return [ad_parameter -package_id [paypal::package_id] PaypalWebscrUrl]
}

ad_proc -private paypal::form::start {} {} {
	upvar paypal_form paypal_form
	set webscr [paypal::webscr_url]
	set paypal_form "<form action=\"$webscr\" method=\"post\">\n"
}
ad_proc -private paypal::form::hidden_value {
	name
	value
} {} {
	upvar paypal_form paypal_form
	append paypal_form "<input type=\"hidden\" name=\"$name\" value=\"$value\">\n"
}

ad_proc -private paypal::form::finish {} {} {
	upvar paypal_form paypal_form
	append paypal_form "</form>\n"
}

ad_proc -private paypal::apply_package_defaults {} {} {
	uplevel 1 {
		set _package_id [paypal::package_id]

		set_unless_set business [ad_parameter -package_id $_package_id BusinessEmail]
		set_unless_set currency_code [ad_parameter -package_id $_package_id DefaultCurrency]
	}
}

