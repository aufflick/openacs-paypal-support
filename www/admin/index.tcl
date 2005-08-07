set package_id [ad_conn package_id]
set return_url [ad_conn url]

set params_url [export_vars -url -base "/shared/parameters" {package_id return_url}]
