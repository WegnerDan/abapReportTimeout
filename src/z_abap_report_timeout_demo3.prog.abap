*&---------------------------------------------------------------------*
*& Report z_abap_report_timeout_demo3
*&---------------------------------------------------------------------*
*& this demonstrates how to replace popup texts
*&---------------------------------------------------------------------*
REPORT z_abap_report_timeout_demo3.

CLASS lcl_timeout DEFINITION
  INHERITING FROM zcl_abap_report_timeout
  CREATE PUBLIC.

  PROTECTED SECTION.
    METHODS popup_stay_or_exit REDEFINITION.
ENDCLASS.

CLASS lcl_timeout IMPLEMENTATION.
  METHOD popup_stay_or_exit.
    super->popup_stay_or_exit( EXPORTING titlebar       = 'Different title'
                                         text_question  = 'You gotta get outta here'
                                         text_button_1  = 'NO!'
                                         icon_button_1  = ''
                                         text_button_2  = 'Okay'
                                         icon_button_2  = ''
                                         default_button = '1'
                                         popup_type     = 'ICON_MESSAGE_CRITICAL'
                               IMPORTING answer         = answer ).
  ENDMETHOD.

ENDCLASS.


CLASS lcl_report DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      run.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

PARAMETERS:
  ptimeout TYPE i DEFAULT 3.



START-OF-SELECTION.
  NEW lcl_report( )->run( ).



CLASS lcl_report IMPLEMENTATION.
  METHOD run.
    NEW lcl_timeout( timeout_in_seconds = ptimeout
                     exit_immediately   = abap_false ).

    WRITE |Timeout in { ptimeout } seconds|.
  ENDMETHOD.

ENDCLASS.
