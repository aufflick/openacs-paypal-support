ad_page_contract {

  @author mark@pumptheory.com
  @creation-date 2005-08-04
  @cvs-id $Id$
} {
}

ns_log Notice "PayPal IPN: received callback at [ns_conn location][ad_conn url]"

paypal::ipn::handle_ipn -form [ns_conn form]

ad_return_template
