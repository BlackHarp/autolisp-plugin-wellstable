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
;;;            '("dlg:dialog{label=\"Таблица колодцев\";"
;;;	    ": popup_list{key=\"netTypeList\"; label =\"Select Well Type\";"
;;;    	    "fixed_width_font=false; width=15; value=0;}"
;;;	    ": popup_list{key=\"wellTopList\"; label =\"Select Well Top\";"
;;;    	    "fixed_width_font=false; width=35; value=0;}"
;;;    	    ":row{ok_cancel;
;;;    	    : button { key = \"help\"; value = \"0\"; fixed_height = true;"
;;;            "alignment = center; label = \"Help\"; } }" "}")
            '("dlg:dialog{label=\"Таблица колодцев\";"
              ":boxed_row {label =\"Выберите тип колодцев\"; fixed_height = true;"
              ":radio_row {"
              ":radio_button {key = \"radio1\"; label = \"ВГ\"; value = 1;}"
              ": radio_button {key = \"radio2\"; label = \"ВД\"; }"
              "} }"
              ":row{"
              ":boxed_column {label =\"Выберите тип ОУЭ\"; fixed_height = true;"
              ":radio_column {"
              ": radio_button {key = \"radio3\"; label = \"ОУЭ-СМ-600\"; value = 1;}"
              ": radio_button {key = \"radio4\"; label = \"ОУЭ-600\"; }"
              "} }"
              ":boxed_column {label =\"Выберите тип решетки\"; fixed_height = true;"
              ":radio_column {"
              ": radio_button {key = \"radio5\"; label = \"ДБ\"; value = 1;}"
              ": radio_button {key = \"radio6\"; label = \"ДМ\"; }"
              "} }"
              "}"
              ":row{ok_cancel;
    	      : button { key = \"help\"; value = \"0\"; fixed_height = true;"
              ;;"alignment = center; "
              "label = \"Справка\"; } }" "}")
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
  (setq netType "ВГ")
  (setq wellTop "ОУЭ-СМ-600")
  (setq helptext (strcat "Таблица колодцев v0.3	Справка! \n\n"
                         "          В программе реализовано построение таблицы водосточных колодцев из "
                         "сборных ж/б изделий типа ВГ с дополнительными кольцами и перепадных колодцев ППК, "
                         "собираемых из типовых колец и днища.\n"
                         "          Таблица дождеприемных колодцев ВД находится в стадии разработки. Пока реализована "
                         "поддержка колодцев типа ВД-8.\n\n"
                         "          Глубина заложения верха плиты перекрытия для колодцев ВГ не превышает 4.0 м "
                         "(Лист 7. Альбом СК 2201-88 ПЗ). Горловина набирается кольцами диаметром 700 мм.\n"
                         "          Высота рабочей камеры перепадных колодцев рассчитывается автоматически из "
                         "параметров чертежа - по разнице абс. отметок верха самой верхней трубы +500мм и лотка "
                         "самой нижней трубы.\n"
                         "          Все количественные характеристики колодцев (скобы, лестницы, материалы) "
                         "рассчитываются исходя из количества элементов конструкции колодцев, а также "
                         "количества и диаметра подсоединяемых труб.\n\n"
                         "PS: Сейчас высота колодцев типа ВГ не может быть меньше 2370мм (высота камеры + ПК "
                         "+ ОУЭ). Колодцы меньшей высоты планируется делать наборными из днища и колец."))

  (setq dlg_res 8)
  (while (< 1 dlg_res)
      (action_tile "radio1" "(setq netType \"ВГ\")")
      (action_tile "radio2" "(setq netType \"ВД\")")
      (action_tile "radio3" "(setq wellTop \"ОУЭ-СМ-600\")")
      (action_tile "radio4" "(setq wellTop \"ОУЭ-600\")")
      (action_tile "radio5" "(setq wellTop \"ДБ\")")
      (action_tile "radio6" "(setq wellTop \"ДМ\")")
      (action_tile "accept" "(done_dialog 1)")
      (action_tile "cancel" "(done_dialog 0)")
      (action_tile "help" "(alert helptext)")

      (setq dlg_res (start_dialog))
      ;;(if (eq dlg_res 5) (alert "Справка!"))
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