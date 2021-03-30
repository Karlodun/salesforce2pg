-- Example configuration, please check for exact fields you need!:
INSERT INTO ciq.salesforce_instances VALUES -- all fields
('your_instance.my.salesforce.com', 'your_organization_id', 'your_username', 'your_pwd', 'session_id', 'security_token')

INSERT INTO ciq.salesforce_instances VALUES -- most required
('your_instance.my.salesforce.com', 'your_organization_id', 'your_username', 'your_pwd')

INSERT INTO ciq.api_table VALUES 
('your_instance.my.salesforce.com', 'Account', 'account', 'LastModifiedDate', 'account_id', ARRAY['postgres'], 'BillingCountry = ''France'''),
('your_instance.my.salesforce.com', 'Contact', 'contact', 'LastModifiedDate', 'contact_id', ARRAY['postgres'], 'Department = ''finance'''),
;

INSERT INTO ciq.api_column VALUES 
-- accounts
('your_instance.my.salesforce.com','Account', 'Id', 'account_id', 1),
('your_instance.my.salesforce.com','Account', 'IsDeleted', 'is_deleted',6),
('your_instance.my.salesforce.com','Account', 'Name', 'office_name',15),
('your_instance.my.salesforce.com','Account', 'BillingStreet', 'street',20),
('your_instance.my.salesforce.com','Account', 'BillingPostalCode', 'postcode',21),
('your_instance.my.salesforce.com','Account', 'BillingCity', 'city',22),
('your_instance.my.salesforce.com','Account', 'BillingState', 'state',23),
('your_instance.my.salesforce.com','Account', 'BillingCountry', 'country',24),
('your_instance.my.salesforce.com','Account', 'BillingLatitude', 'lat',31),
('your_instance.my.salesforce.com','Account', 'BillingLongitude', 'lon',32),
('your_instance.my.salesforce.com','Account', 'BillingGeocodeAccuracy', 'gc_accuracy',33),
('your_instance.my.salesforce.com','Account', 'Phone', 'phone',41),
('your_instance.my.salesforce.com','Account', 'Website', 'url',42),
('your_instance.my.salesforce.com','Account', 'LastModifiedDate', 'last_modified',51),
-- contacts
('your_instance.my.salesforce.com','Contact', 'Id', 'contact_id', 1),
('your_instance.my.salesforce.com','Contact', 'IsDeleted', 'is_deleted',6),
('your_instance.my.salesforce.com','Contact', 'AccountID', 'account_id', 17),
('your_instance.my.salesforce.com','Contact', 'Salutation', 'salutation', 20),
('your_instance.my.salesforce.com','Contact', 'Title', 'title', 21),
('your_instance.my.salesforce.com','Contact', 'FirstName', 'first_name', 22),
('your_instance.my.salesforce.com','Contact', 'LastName', 'last_name', 23),
('your_instance.my.salesforce.com','Contact', 'Name', 'full_name', 24),
('your_instance.my.salesforce.com','Contact', 'Email', 'email', 25),
('your_instance.my.salesforce.com','Contact', 'Phone', 'phone', 26),
('your_instance.my.salesforce.com','Contact', 'MobilePhone', 'mobile', 27),
('your_instance.my.salesforce.com','Contact', 'Department', 'department', 31),
('your_instance.my.salesforce.com','Contact', 'LastModifiedDate', 'last_modified',51)
('your_instance.my.salesforce.com','Contact', 'CreatedDate', 'created_date',71)
