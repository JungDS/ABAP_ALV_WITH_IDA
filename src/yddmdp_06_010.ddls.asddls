@AbapCatalog.sqlViewName: 'YVMDP_06_010'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'IDA Test 용도 Data Definition'
define view YDDMDP_06_010 as select from ytmdp_06_010 {
    key mandt as Mandt,
    key matnr as Matnr,
    mtart as Mtart,
    matkl as Matkl,
    meins as Meins,
    
    @Semantics.quantity.unitOfMeasure: 'Gewei'
    brgew as Brgew,
    
    @Semantics.quantity.unitOfMeasure: 'Gewei'
    ntgew as Ntgew,
    
    @Semantics.unitOfMeasure: true
    gewei as Gewei,
    
    
    @Semantics.quantity.unitOfMeasure: 'Voleh'
    volum as Volum,
    
    @Semantics.unitOfMeasure: true
    voleh as Voleh,
    
    spart as Spart,
    
    laeng as Laeng,
    
    @Semantics.quantity.unitOfMeasure: 'Meabm'
    breit as Breit,
    @Semantics.quantity.unitOfMeasure: 'Meabm'
    hoehe as Hoehe,
    @Semantics.unitOfMeasure: true
    meabm as Meabm,
    
    prdha as Prdha
}
