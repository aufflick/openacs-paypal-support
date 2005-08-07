create sequence paypal_ipn_log_seq;

create table paypal_ipn_log (
    ipn_log_id integer unique not null,
    txn_id varchar unique not null,
    business varchar,
    item_name varchar,
    currency_code varchar,
    amount numeric(9,2),
    callback varchar,
    callback_response varchar,
    tax numeric(9,2),
    shipping numeric(9,2),
    invoice varchar,
    payment_date timestamp with time zone,
    first_name varchar,
    last_name varchar,
    payment_type varchar,
    quantity integer,
    payer_status varchar,
    test_ipn boolean,
    payer_email varchar,
    receiver_email varchar,
    memo varchar,
    payment_status varchar,
    ipn_qs varchar,
    ipn_verified boolean
);
