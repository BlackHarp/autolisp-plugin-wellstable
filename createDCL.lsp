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
        '("dlg:dialog{label=\"Oaaeeoa Eieiaoaa\";"
	": popup_list{key=\"netTypeList\"; label =\"Select Well Type\";"
    	"fixed_width_font=false; width=15; value=0;}"
	": popup_list{key=\"wellTopList\"; label =\"Select Well Top\";"
    	"fixed_width_font=false; width=35; value=0;}"
    	"ok_cancel;" "}")
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
  
  (action_tile "accept" "(saveVars) (done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")

  (setq dlg_res (start_dialog))
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