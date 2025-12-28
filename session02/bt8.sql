use demo02;


create table customer(
customer_id char(10) primary key,
full_name varchar(50) not null,
citizen_id char(12) not null unique,
phone varchar(15) not null unique
);


create table account(
account_id char(10) primary key,
customer_id char(10) not null,
balance decimal(15,2) not null check(balance >= 0),
foreign key(customer_id) references customer(customer_id)
);


create table partner(
partner_id char(10) primary key,
partner_name varchar(50) not null unique
);


create table tuition_bill(
bill_id char(10) primary key,
partner_id char(10) not null,
customer_id char(10) not null,
amount decimal(15,2) not null check(amount > 0),
status varchar(20) not null default 'Unpaid',
foreign key(partner_id) references partner(partner_id),
foreign key(customer_id) references customer(customer_id)
);


create table transaction_history(
transaction_id char(10) primary key,
account_id char(10) not null,
bill_id char(10) not null unique,
amount decimal(15,2) not null check(amount > 0),
transaction_date datetime not null default current_timestamp,
status varchar(20) not null default 'Pending',
foreign key(account_id) references account(account_id),
foreign key(bill_id) references tuition_bill(bill_id)
);
