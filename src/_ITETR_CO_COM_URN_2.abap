class /ITETR/CO_COM_URN_2 definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods OP1
    importing
      !INPUT type /ITETR/COM_MESSAGE1
    exporting
      !OUTPUT type /ITETR/COM_MESSAGE1
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS /ITETR/CO_COM_URN_2 IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = '/ITETR/CO_COM_URN_2'
    logical_port_name   = logical_port_name
  ).

  endmethod.


  method OP1.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'OP1'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.