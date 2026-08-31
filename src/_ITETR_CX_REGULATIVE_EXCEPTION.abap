CLASS /itetr/cx_regulative_exception DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PROTECTED .

  PUBLIC SECTION.

    DATA mt_return TYPE bapiret2_t READ-ONLY .

    METHODS constructor
      IMPORTING
        !textid    LIKE textid OPTIONAL
        !previous  LIKE previous OPTIONAL
        !mt_return TYPE bapiret2_t OPTIONAL .

    CLASS-METHODS create_by_bapiret2
      IMPORTING
        !is_return         TYPE bapiret2
      RETURNING
        VALUE(rx_instance) TYPE REF TO /itetr/cx_regulative_exception .

    CLASS-METHODS create_by_exception
      IMPORTING
        !ix_exception      TYPE REF TO cx_root
      RETURNING
        VALUE(rx_instance) TYPE REF TO /itetr/cx_regulative_exception .

    CLASS-METHODS create_by_message
      IMPORTING
        !iv_msgid          TYPE msgid DEFAULT '/ITETR/REGULATIVE'
        !iv_msgno          TYPE sy-msgno
        !iv_msgv1          TYPE clike OPTIONAL
        !iv_msgv2          TYPE clike OPTIONAL
        !iv_msgv3          TYPE clike OPTIONAL
        !iv_msgv4          TYPE clike OPTIONAL
      RETURNING
        VALUE(rx_instance) TYPE REF TO /itetr/cx_regulative_exception .

    METHODS add_bapiret2_to_messages
      IMPORTING
        !is_return TYPE bapiret2 .

    METHODS get_single_message
      RETURNING
        VALUE(rs_return) TYPE bapiret2.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ITETR/CX_REGULATIVE_EXCEPTION IMPLEMENTATION.


  METHOD add_bapiret2_to_messages.
    APPEND is_return TO mt_return.
  ENDMETHOD.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        textid   = textid
        previous = previous.
    me->mt_return = mt_return .
  ENDMETHOD.


  METHOD create_by_bapiret2.
    CREATE OBJECT rx_instance.
    rx_instance->add_bapiret2_to_messages( is_return ).
  ENDMETHOD.


  METHOD create_by_exception.
    DATA: lv_error      TYPE bapi_msg,
          ls_return     TYPE bapiret2,
          lv_long_error TYPE string.
    lv_error = ix_exception->get_text( ).
    lv_long_error = ix_exception->get_longtext( ).
    CREATE OBJECT rx_instance.
    ls_return-id = '/ITETR/REGULATIVE'.
    ls_return-type = 'E'.
    ls_return-number = '000'.
    ls_return-message_v1 = lv_error(50).
    ls_return-message_v2 = lv_error+50(50).
    ls_return-message_v3 = lv_error+100(50).
    ls_return-message_v4 = lv_error+150(*).
    rx_instance->add_bapiret2_to_messages( ls_return ).
  ENDMETHOD.


  METHOD create_by_message.
    DATA ls_return TYPE bapiret2.
    CREATE OBJECT rx_instance.
    ls_return-id = iv_msgid.
    ls_return-type = 'E'.
    ls_return-number = iv_msgno.
    ls_return-message_v1 = iv_msgv1.
    ls_return-message_v2 = iv_msgv2.
    ls_return-message_v3 = iv_msgv3.
    ls_return-message_v4 = iv_msgv4.
    rx_instance->add_bapiret2_to_messages( ls_return ).
  ENDMETHOD.


  METHOD get_single_message.
    READ TABLE mt_return INTO rs_return INDEX 1.
  ENDMETHOD.
ENDCLASS.