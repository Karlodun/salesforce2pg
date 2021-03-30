-- Example configuration, please check for exact fields you need!:
INSERT INTO ciq.salesforce_instances VALUES -- all fields
('your_instance.my.salesforce.com', 'your_organization_id', 'your_username', 'your_pwd', 'session_id', 'security_token')

INSERT INTO ciq.salesforce_instances VALUES -- most required
('your_instance.my.salesforce.com', 'your_organization_id', 'your_username', 'your_pwd')

INSERT INTO ciq.api_table VALUES 
('Account', 'account', 'LastModifiedDate', 'account_id', ARRAY['postgres'], 'BillingCountry = ''France'''),
('Contact', 'contact', 'LastModifiedDate', 'contact_id', ARRAY['postgres'], 'Department = ''finance'''),
;

INSERT INTO ciq.api_column VALUES 
-- accounts
('Account', 'Id', 'account_id', 1),
('Account', 'IsDeleted', 'is_deleted',6),
('Account', 'Name', 'office_name',15),
('Account', 'BillingStreet', 'street',20),
('Account', 'BillingPostalCode', 'postcode',21),
('Account', 'BillingCity', 'city',22),
('Account', 'BillingState', 'state',23),
('Account', 'BillingCountry', 'country',24),
('Account', 'BillingLatitude', 'lat',31),
('Account', 'BillingLongitude', 'lon',32),
('Account', 'BillingGeocodeAccuracy', 'gc_accuracy',33),
('Account', 'Phone', 'phone',41),
('Account', 'Website', 'url',42),
('Account', 'LastModifiedDate', 'last_modified',51),
-- contacts
('Contact', 'Id', 'contact_id', 1),
('Contact', 'IsDeleted', 'is_deleted',6),
('Contact', 'AccountID', 'account_id', 17),
('Contact', 'Salutation', 'salutation', 20),
('Contact', 'Title', 'title', 21),
('Contact', 'FirstName', 'first_name', 22),
('Contact', 'LastName', 'last_name', 23),
('Contact', 'Name', 'full_name', 24),
('Contact', 'Email', 'email', 25),
('Contact', 'Phone', 'phone', 26),
('Contact', 'MobilePhone', 'mobile', 27),
('Contact', 'Department', 'department', 31),
('Contact', 'LastModifiedDate', 'last_modified',51)
('Contact', 'CreatedDate', 'created_date',71)
