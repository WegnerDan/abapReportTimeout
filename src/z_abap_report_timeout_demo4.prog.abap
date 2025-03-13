*&---------------------------------------------------------------------*
*& Report z_abap_report_timeout_demo4
*&---------------------------------------------------------------------*
*& something something
*&---------------------------------------------------------------------*
REPORT z_abap_report_timeout_demo4.

CLASS lcl_report DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      run.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      timeout       TYPE REF TO zcl_abap_report_timeout,
      timeout_count TYPE i.
    METHODS:
      handle_timeout_reached FOR EVENT timeout_reached OF zcl_abap_report_timeout IMPORTING sender.
ENDCLASS.

PARAMETERS:
  ptimeout TYPE i DEFAULT 3,
  prepeats TYPE i DEFAULT 2.



START-OF-SELECTION.
  NEW lcl_report( )->run( ).



CLASS lcl_report IMPLEMENTATION.
  METHOD run.
    timeout = NEW #( timeout_in_seconds = ptimeout
                     exit_immediately   = abap_false ).

    SET HANDLER handle_timeout_reached FOR timeout.

    WRITE |Timeout in { ptimeout } seconds|.
  ENDMETHOD.

  METHOD handle_timeout_reached.
    timeout_count = timeout_count + 1.
    IF timeout_count > prepeats.
      sender->cancel( ).
      MESSAGE 'Enough already, goodbye' TYPE 'S'.
      sender->leave_program( ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
