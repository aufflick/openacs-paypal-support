ad_library {
    Callback code for paypal interaction

    @author Mark Aufflick (mark@pumtheory.com)
    @creation-date 2005-07-31
    @cvs-id $Id$
}


ad_proc -public -callback paypal::ipn::callback {
	-ipn_ns_set:required
} {
	Callback to implement
} -

