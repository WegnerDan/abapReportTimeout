CLASS zcl_abap_report_timeout DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    DATA:
      timeout_in_seconds TYPE i READ-ONLY,
      exit_immediately   TYPE abap_bool READ-ONLY,
      timer              TYPE REF TO cl_gui_timer READ-ONLY.


    METHODS:
      constructor IMPORTING timeout_in_seconds TYPE i
                            exit_immediately   TYPE abap_bool DEFAULT abap_false.

  PROTECTED SECTION.

    METHODS:
      handle_timer_finished FOR EVENT finished OF cl_gui_timer,

      exit_report,

      popup_stay_or_exit.

ENDCLASS.



CLASS zcl_abap_report_timeout IMPLEMENTATION.
  METHOD constructor.
    me->timeout_in_seconds = timeout_in_seconds.
    me->exit_immediately   = exit_immediately.

    timer = NEW #( ).

    SET HANDLER handle_timer_finished FOR timer.

    timer->interval = timeout_in_seconds.
    timer->run( ).
  ENDMETHOD.

  METHOD handle_timer_finished.
    IF exit_immediately = abap_true.
      exit_report( ).
      RETURN.
    ENDIF.


  ENDMETHOD.

  METHOD exit_report.
    LEAVE PROGRAM.
  ENDMETHOD.

  METHOD popup_stay_or_exit.
    DATA: popup_answer TYPE c length 1.
*call function 'POPUP_TO_CONFIRM'
*  EXPORTING
*    titlebar              = 'Timeout reached'
*    text_question         = 'Do you want to stay or leave this program?'
*    text_button_1         = 'Stay'
*    icon_button_1         = SPACE    " Icon on first pushbutton
*    text_button_2         = 'Leave'
*    icon_button_2         = SPACE    " Icon on second pushbutton
*    default_button        = '1'
*    display_cancel_button = abap_false
**    start_column          = 25    " Column in which the POPUP begins
**    start_row             = 6    " Line in which the POPUP begins
**    popup_type            =     " Icon type
**    iv_quickinfo_button_1 = SPACE    " Quick Info on First Pushbutton
**    iv_quickinfo_button_2 = SPACE    " Quick Info on Second Pushbutton
*  IMPORTING
*    answer                = popup_answer
*
*  .
  ENDMETHOD.

ENDCLASS.
