-- Example configuration, please check for exact fields you need!:
INSERT INTO salesforce2pg.salesforce_instances VALUES -- all fields
('your_instance.my.salesforce.com', 'your_organization_id', 'your_username', 'your_pwd', 'session_id', 'security_token')

INSERT INTO salesforce2pg.salesforce_instances VALUES -- most required
('your_instance.my.salesforce.com', 'your_organization_id', 'your_username', 'your_pwd')

INSERT INTO salesforce2pg.api_table VALUES 
('your_instance.my.salesforce.com', 'BusObject', 'bus_object', 'LastModifiedDate', 'bus_object_id', ARRAY['postgres'], 'SomeAttribute = ''some_value'''),
;

INSERT INTO salesforce2pg.api_column VALUES 
('your_instance.my.salesforce.com','BusObject', 'Id', 'account_id', 1),
('your_instance.my.salesforce.com','BusObject', 'IsDeleted', 'is_deleted',6),
('your_instance.my.salesforce.com','BusObject', 'Attr1', 'attribute_1',15),
('your_instance.my.salesforce.com','BusObject', 'Attr7', 'attribute_512',20),
('your_instance.my.salesforce.com','BusObject', 'Attr8', 'another_attribute',21),
('your_instance.my.salesforce.com','BusObject', 'Attr52', 'and_another_one',42),
('your_instance.my.salesforce.com','BusObject', 'LastModifiedDate', 'last_modified',51);
