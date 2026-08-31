class /ITETR/CL_REGULATIVE_ARCHIVE definition
  public
  final
  create public .

public section.

  constants:
    BEGIN OF mc_content_types.
    CONSTANTS pdf  TYPE /itetr/com_e_conty VALUE 'PDF' ##NO_TEXT.
    CONSTANTS ubl  TYPE /itetr/com_e_conty VALUE 'UBL' ##NO_TEXT.
    CONSTANTS html TYPE /itetr/com_e_conty VALUE 'HTML' ##NO_TEXT.
    CONSTANTS END OF mc_content_types .

  class-methods CREATE
    importing
      !IT_ARCHIVES type /ITETR/COM_TT_ARCHIVE
      !IV_COMMIT type XFELD default ABAP_TRUE .
  class-methods GET_SINGLE_DOCUI
    importing
      !IV_DOCUI type /ITETR/COM_E_DOCUI
      !IV_CONTY type /ITETR/COM_E_CONTY
    returning
      value(RV_CONTENT) type /ITETR/COM_E_CONTN .
  class-methods GET_SINGLE_EARCHIVE
    importing
      !IV_DOCUI type /ITETR/COM_E_DOCUI
      !IV_CONTY type /ITETR/COM_E_CONTY
    returning
      value(RV_CONTENT) type /ITETR/COM_E_CONTN .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ITETR/CL_REGULATIVE_ARCHIVE IMPLEMENTATION.


  METHOD create.
    DATA: lt_archive  TYPE TABLE OF /itetr/com_arcd,
          ls_archive  TYPE /itetr/com_arcd,
          lt_archives TYPE /itetr/com_tt_archive,
          ls_archives TYPE /itetr/com_s_archive.
    lt_archives = it_archives.
    LOOP AT lt_archives INTO ls_archives.
      MOVE-CORRESPONDING ls_archives TO ls_archive.
      CALL FUNCTION 'GUID_CREATE'
        IMPORTING
          ev_guid_16 = ls_archive-arcid.
      APPEND ls_archive TO lt_archive.
      CLEAR ls_archive.
    ENDLOOP.
    CHECK lt_archive IS NOT INITIAL.
    INSERT /itetr/com_arcd FROM TABLE lt_archive.
    CHECK iv_commit IS NOT INITIAL.
    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD get_single_docui.
    SELECT SINGLE contn
      FROM /itetr/com_arcd
      INTO rv_content
      WHERE docui = iv_docui
        AND conty = iv_conty.
  ENDMETHOD.


  method GET_SINGLE_EARCHIVE.
  endmethod.
ENDCLASS.