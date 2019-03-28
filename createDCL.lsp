(defun createDCL (/ startTime)
;;;  (setq startTime (getvar "millisecs"))
  (setq file   (strcat (vl-string-right-trim
           "\\"
           (vla-get-tempfilepath
       (vla-get-files
         (vla-get-preferences (vlax-get-acad-object))
         ) ;_ end of vla-get-files
       ) ;_ end of vla-get-tempfilepath
           ) ;_ end of vl-string-right-trim
         "\\dlg.dcl"
         ) ;_ end of strcat
      handle (open file "w")
      ) ;_ end of setq
	(foreach item
;;;            '("dlg:dialog{label=\"������� ��������\";"
;;;	    ": popup_list{key=\"netTypeList\"; label =\"Select Well Type\";"
;;;    	    "fixed_width_font=false; width=15; value=0;}"
;;;	    ": popup_list{key=\"wellTopList\"; label =\"Select Well Top\";"
;;;    	    "fixed_width_font=false; width=35; value=0;}"
;;;    	    ":row{ok_cancel;
;;;    	    : button { key = \"help\"; value = \"0\"; fixed_height = true;"
;;;            "alignment = center; label = \"Help\"; } }" "}")
            '("dlg:dialog{label=\"������� ��������\";"
              ":boxed_row {label =\"�������� ��� ��������\"; fixed_height = true;"
              ":radio_row {"
              ":radio_button {key = \"radio1\"; label = \"��\"; value = 1;}"
              ": radio_button {key = \"radio2\"; label = \"��\"; }"
              "} }"
              ":row{"
              ":boxed_column {label =\"�������� ��� ���\"; fixed_height = true;"
              ":radio_column {"
              ": radio_button {key = \"radio3\"; label = \"���-��-600\"; value = 1;}"
              ": radio_button {key = \"radio4\"; label = \"���-600\"; }"
              "} }"
              ":boxed_column {label =\"�������� ��� �������\"; fixed_height = true;"
              ":radio_column {"
              ": radio_button {key = \"radio5\"; label = \"��\"; value = 1;}"
              ": radio_button {key = \"radio6\"; label = \"��\"; }"
              "} }"
              "}"
              ":row{ok_cancel;
    	      : button { key = \"help\"; value = \"0\"; fixed_height = true;"
              ;;"alignment = center; "
              "label = \"�������\"; } }" "}")
  	    (write-line item handle)
  	) ;_ end of foreach
	(close handle)
  (setq dcl_id (load_dialog file))
  (new_dialog "dlg" dcl_id)

  (start_list "netTypeList" 3)
  (mapcar 'add_list netTypeList)
  (end_list)

  (start_list "wellTopList" 3)
  (mapcar 'add_list wellTopList)
  (end_list)
  (setq netType "��")
  (setq wellTop "���-��-600")
  (setq helptext (strcat "������� �������� v0.3	�������! \n\n"
                         "          � ��������� ����������� ���������� ������� ����������� �������� �� "
                         "������� �/� ������� ���� �� � ��������������� �������� � ���������� �������� ���, "
                         "���������� �� ������� ����� � �����.\n"
                         "          ������� ������������� �������� �� ��������� � ������ ����������. ���� ����������� "
                         "��������� �������� ���� ��-8.\n\n"
                         "          ������� ��������� ����� ����� ���������� ��� �������� �� �� ��������� 4.0 � "
                         "(���� 7. ������ �� 2201-88 ��). ��������� ���������� �������� ��������� 700 ��.\n"
                         "          ������ ������� ������ ���������� �������� �������������� ������������� �� "
                         "���������� ������� - �� ������� ���. ������� ����� ����� ������� ����� +500�� � ����� "
                         "����� ������ �����.\n"
                         "          ��� �������������� �������������� �������� (�����, ��������, ���������) "
                         "�������������� ������ �� ���������� ��������� ����������� ��������, � ����� "
                         "���������� � �������� �������������� ����.\n\n"
                         "PS: ������ ������ �������� ���� �� �� ����� ���� ������ 2370�� (������ ������ + �� "
                         "+ ���). ������� ������� ������ ����������� ������ ��������� �� ����� � �����."))

  (setq dlg_res 8)
  (while (< 1 dlg_res)
      (action_tile "radio1" "(setq netType \"��\")")
      (action_tile "radio2" "(setq netType \"��\")")
      (action_tile "radio3" "(setq wellTop \"���-��-600\")")
      (action_tile "radio4" "(setq wellTop \"���-600\")")
      (action_tile "radio5" "(setq wellTop \"��\")")
      (action_tile "radio6" "(setq wellTop \"��\")")
      (action_tile "accept" "(done_dialog 1)")
      (action_tile "cancel" "(done_dialog 0)")
      (action_tile "help" "(alert helptext)")

      (setq dlg_res (start_dialog))
      ;;(if (eq dlg_res 5) (alert "�������!"))
  )
  (unload_dialog dcl_id)
  
;;;  (princ "\n")
;;;  (princ (strcat "(createDCL)....."
;;;		 (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  (princ)

)

(defun saveVars ()

  ;;;--- Get the selected item from the first list
  (setq sStr1 (get_tile "netTypeList"))

  ;;;--- Make sure something was selected... 
  (if(= sStr1 "") 
    (setq netType nil) 
    (setq netType (nth (atoi sStr1) netTypeList))
  )
  
  ;;;--- Get the selected item from the second list
  (setq sStr2 (get_tile "wellTopList"))

  ;;;--- Make sure something was selected... 
  (if(= sStr2 "") 
    (setq wellTop nil) 
    (setq wellTop (nth (atoi sStr2) wellTopList))
  ) 

)