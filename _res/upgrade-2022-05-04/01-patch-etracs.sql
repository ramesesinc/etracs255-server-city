-- ## 2022-04-07

insert into sys_rule_fact_field (
  objid, parentid, name, title, sortorder, [handler], datatype, vardatatype 
) 
select 
  (f.objid + '.year') as objid, f.objid as parentid, 'year' as name, 'Year' as title, 
  4 as sortorder, 'integer' as handler, 'integer' as datatype, 'integer' as vardatatype 
from sys_rule_fact f 
  left join sys_rule_fact_field ff on (ff.parentid = f.objid and ff.name = 'year') 
where f.factclass = 'bpls.facts.BillItem'
  and ff.objid is null 
; 



-- ## 2022-04-11

INSERT INTO sys_rule_fact ([objid], name, title, factclass, sortorder, handler, defaultvarname, [dynamic], lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUBarangay', 'treasury.facts.LGUBarangay', 'LGU Barangay', 'treasury.facts.LGUBarangay', '100', NULL, 'BRGY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');
INSERT INTO sys_rule_fact ([objid], name, title, factclass, sortorder, handler, defaultvarname, [dynamic], lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUMunicipality', 'treasury.facts.LGUMunicipality', 'LGU Municipality', 'treasury.facts.LGUMunicipality', '100', NULL, 'MUNI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');
INSERT INTO sys_rule_fact ([objid], name, title, factclass, sortorder, handler, defaultvarname, [dynamic], lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUProvince', 'treasury.facts.LGUProvince', 'LGU Province', 'treasury.facts.LGUProvince', '100', NULL, 'PROV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');

INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.orgid', 'treasury.facts.LGUBarangay', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.orgclass', 'treasury.facts.LGUBarangay', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.root', 'treasury.facts.LGUBarangay', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.orgid', 'treasury.facts.LGUMunicipality', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.orgclass', 'treasury.facts.LGUMunicipality', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.root', 'treasury.facts.LGUMunicipality', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.orgid', 'treasury.facts.LGUProvince', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.orgclass', 'treasury.facts.LGUProvince', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.root', 'treasury.facts.LGUProvince', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);

INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUBarangay');
INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUMunicipality');
INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUProvince');


INSERT INTO sys_rule_fact ([objid], name, title, factclass, sortorder, handler, defaultvarname, [dynamic], lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.CollectionType', 'treasury.facts.CollectionType', 'Collection Type', 'treasury.facts.CollectionType', '0', NULL, 'CT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', NULL);

INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.CollectionType.objid', 'treasury.facts.CollectionType', 'objid', 'ID', 'string', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.CollectionType.name', 'treasury.facts.CollectionType', 'name', 'Name', 'string', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field ([objid], parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, [required], vardatatype, lovname) VALUES ('treasury.facts.CollectionType.handler', 'treasury.facts.CollectionType', 'handler', 'Handler', 'string', '2', 'lookup', 'collectiontype_handler:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);

INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.CollectionType');
