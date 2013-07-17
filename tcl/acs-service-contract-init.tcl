# Loop over actual bindings, finding every impl alias for each contract operation
db_foreach impl_operation {
    select ia.impl_contract_name, 
           ia.impl_operation_name,
           ia.impl_name,
           ia.impl_alias,
           ia.impl_pl
    from   acs_sc_bindings b,
           acs_sc_impl_aliases ia
    where  ia.impl_id = b.impl_id
} {
    # fraber 130717:
    # Fixed broken LDAP issue, because a database error in one entry
    # stopped the processing of all other entries
    if {[catch {
	# This creates the AcsSc.Contract.Operation.Impl wrapper proc for this implementation
        acs_sc_proc $impl_contract_name $impl_operation_name $impl_name $impl_alias $impl_pl
    } err_msg]} {
        ns_log error [ad_log_stack_trace]
    }
}
