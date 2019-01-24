(defun createWellTable (/ startTime tableRows tableColumns WellTable)
  (setvar "REGENMODE" 0)

  (setq oldctablestyle (getvar "ctablestyle"))
  (setq tableStyleDict (vla-item (vla-get-dictionaries (vla-get-activedocument (vlax-get-acad-object)))
				 "ACAD_TABLESTYLE"))
  (if (member
	"ITERIS-C3DNU-PVIEW-SIGN"
	(mapcar
	  (function (lambda (x) (vla-get-name x)))
	  ((lambda (/ _res)
	     (vlax-for item tableStyleDict
	       (setq _res (cons item _res)))
	     (reverse _res)
	     )
	    )
	  )
	)
    ;;(princ "Ok")
    
    (setvar "ctablestyle" "ITERIS-C3DNU-PVIEW-SIGN")
  )
  (setq tableRows 3)
  (setq tableColumns 8)
  (setq	WellTable (vla-addtable
		    MySpace
		    ;; Set Insert Point
		    (vlax-3d-point (setq Point (getpoint "Where? ")))
		    ;; Row Number
		    tableRows
		    ;;(+ (sslength objSet) 3)
		    ;; Column Nuber
		    tableColumns
		    ;; Row Height
		    TitleHeight
		    ;; Column Width
		    ColumnWidth
		  )
  )
  (setvar "ctablestyle" oldctablestyle)
  (setq startTime (getvar "millisecs"))
  ;;(vla-settablestyle)
  (vla-MergeCells WellTable 1 2 0 0)
  (vla-MergeCells WellTable 1 1 1 2)
  (vla-MergeCells WellTable 1 2 3 3)
  (vla-MergeCells WellTable 1 2 4 4)
  (vla-MergeCells WellTable 1 2 5 5)
  (vla-MergeCells WellTable 1 2 6 6)
  
  (vla-SetTextHeight WellTable acTitleRow TitleRowHeight)
  (vla-SetTextHeight WellTable acHeaderRow HeaderRowHeight)
  ;;(vla-SetTextHeight WellTable acDataRow DataRowHeight)
  ;;(vla-setcellalignment WellTable acmiddlecenter)
  ;;(vla-setDataFormat WellTable 3 3 0 "%lu2%pr0%ds44")

  ;; Insert Tabel Name
  (vla-settext WellTable 0 0 "Таблица колодцев")
  ;; Insert Column Captions
  (vla-settext WellTable 1 0 "# колодцa")
  (vla-settext WellTable 1 1 "Отметки, м")
  (vla-settext WellTable 2 1 "планировки")
  ;;(vla-setcellalignment WellTable 2 1 acmiddlecenter)
  (vla-settext WellTable 2 2 "лотка трубы")
  ;;(vla-setcellalignment WellTable 2 2 acmiddlecenter)
  (vla-settext WellTable 1 3 "Марка колодцa")
  (vla-settext WellTable 1 4 "Н колодцa по проф., м")
  (vla-settext WellTable 1 5 "Н колодцa полная, м")
  (vla-settext WellTable 1 6 "Н горл., м")
  (vla-settext WellTable 1 7 "Рабочая камера")
  (vla-settext WellTable 2 7 "Н, мм")
  (foreach wellDiameter wellDiameterList
    (vla-InsertColumns WellTable tableColumns ColumnWidth 3)
    (vla-MergeCells WellTable 1 1 7 (+ tableColumns 2))
    
    (vla-settext WellTable 2 tableColumns (strcat wellType "-" wellDiameter))
    ;;(vla-setcellalignment WellTable 2 tableColumns acmiddlecenter)
    (vla-settext WellTable 2 (+ tableColumns 1) (strcat "К-" wellDiameter "-5"))
    ;;(vla-setcellalignment WellTable 2 (+ tableColumns 1) acmiddlecenter)
    (vla-settext WellTable 2 (+ tableColumns 2) (strcat "К-" wellDiameter "-10"))
    ;;(vla-setcellalignment WellTable 2 (+ tableColumns 2) acmiddlecenter)
    
    (setq tableColumns (+ tableColumns 3))
    
    (vla-InsertColumns WellTable tableColumns ColumnWidth 1)
    (vla-settext WellTable 1 tableColumns "Плиты перекрытия")
    (vla-settext WellTable 2 tableColumns (strcat "ПК-" wellDiameter))
    ;;(vla-setcellalignment WellTable 2 tableColumns acmiddlecenter)
  )
  (setq tableColumns (1+ tableColumns))
  (vla-InsertColumns WellTable tableColumns ColumnWidth 5)
  (vla-MergeCells WellTable 1 1 tableColumns (+ tableColumns 3))
  (vla-settext WellTable 1 tableColumns "Кольца горловины (добор)")
  (vla-settext WellTable 2 tableColumns "К-7-1.5")
  ;;(vla-setcellalignment WellTable 2 tableColumns acmiddlecenter)
  (vla-settext WellTable 2 (+ tableColumns 1) "К-7-5")
  ;;(vla-setcellalignment WellTable 2 (+ tableColumns 1) acmiddlecenter)
  (vla-settext WellTable 2 (+ tableColumns 2) "К-7-10")
  ;;(vla-setcellalignment WellTable 2 (+ tableColumns 2) acmiddlecenter)
  (vla-settext WellTable 2 (+ tableColumns 3) "КО-660")
  ;;(vla-setcellalignment WellTable 2 (+ tableColumns 3) acmiddlecenter)
  (vla-MergeCells WellTable 1 2 (+ tableColumns 4) (+ tableColumns 4))
  (vla-settext WellTable 1 (+ tableColumns 4) (strcat "Опорно-укрывной элемент " wellTop))
  
  
  (setq tableColumns (+ tableColumns 5))
  (vla-InsertColumns WellTable tableColumns ColumnWidth 1)
  (vla-MergeCells WellTable 1 2 tableColumns tableColumns)
  (vla-settext WellTable 1 tableColumns "Остаток")
  
;;;  (princ "\n")
;;;  (princ (strcat "(createTableHeader)....."
;;;		 (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  (princ "\n")

  (foreach well wellDataList
      (progn
	
	(setWellParams)
	(getAddonsCount)
	(setRowData)
	
      )
  )
  ;;(alert (getvar "REGENMODE"))
  (setvar "REGENMODE" 1)
  
  (princ "\n")
  (princ (strcat "(createWellTable)....."
		 (vl-prin1-to-string (- (getvar "millisecs") startTime))))
  (princ "\n")
)

(defun getWellBaseAddonsCount (AddonsHeight BaseAddon5Count BaseAddon10Count /)

  (if (< AddonsHeight wellBaseAddon5Height)
    (setq BaseAddon5Count
	   (+ BaseAddon5Count 1)
    )
    (progn
      (if (< AddonsHeight wellBaseAddon10Height)
	(setq BaseAddon10Count
	       (+ BaseAddon10Count 1)
	)
	(getWellBaseAddonsCount
	  (rem AddonsHeight wellBaseAddon10Height)
	  BaseAddon5Count
	  BaseAddon10Count)
      )
    )
  )
  (list BaseAddon5Count BaseAddon10Count)
)

(defun getWellTopAddonsCount (TopAddonsHeight	   TopAddon1000Count
			      TopAddon500Count	   TopAddon150Count
			      TopAddon66Count	   /
			     )

  (defun *error* (msg)
      (princ (strcat "\n getWellTopAddonsCount error : " msg))
      (princ)
      ) ;_ end of defun
  
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon1000Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon1000Count
			    (+ TopAddon1000Count AddonsHeightDiv)
	  TopAddonsHeight	    (- TopAddonsHeight
			       (* wellTopAddon1000Height TopAddon1000Count)
			    )
    )
  )
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon500Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon500Count
			   (+ TopAddon500Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon500Height TopAddon500Count)
			   )
    )
  )
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon150Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon150Count (+ TopAddon150Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon150Height TopAddon150Count)
			   )
    )
  )
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon66Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon66Count (+ TopAddon66Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon66Height TopAddon66Count)
			   )
    )
  )

  (list	TopAddon1000Count
	TopAddon500Count
	TopAddon150Count
	TopAddon66Count
  )
)

(defun setWellParams (/ startTime)
  	(setq startTime (getvar "millisecs"))

	(setq wellName (cdr (assoc "Name" well))
	      wellRimElevation (cdr (assoc "RimElevation" well))
	      wellSumpElevation (cdr (assoc "SumpElevation" well))
	      wellPipeLowestBottomDepth (cdr (assoc "PipeLowestBottomDepth" well))
	      wellStructureInnerDiameterOrWidth (cdr (assoc "StructureInnerDiameterOrWidth" well))
	      wellStructureInnerDiameter (rtos (* wellStructureInnerDiameterOrWidth 10) 2 0)
	      wellStructureProfileHeight (- wellRimElevation wellSumpElevation)
	      wellStructureFullHeight (+ wellStructureProfileHeight wellStructureBottom)
	      wellBaseHeight (last (assoc (strcat wellType "-" wellStructureInnerDiameter)
					  (last (assoc wellType wellTypes))))
	      wellBaseAddon5Height (last (assoc (strcat "К-" wellStructureInnerDiameter "-5")
					  (last (assoc wellType wellTypes))))
	      wellBaseAddon10Height (last (assoc (strcat "К-" wellStructureInnerDiameter "-10")
					  (last (assoc wellType wellTypes))))
	      wellBaseTopHeight (last (assoc (strcat "ПК-" wellStructureInnerDiameter)
					  (last (assoc wellType wellTypes))))
	      wellTopAddon1000Height (last (assoc "К-7-10" (last (assoc "КГ" wellTypes))))
	      wellTopAddon500Height (last (assoc "К-7-5" (last (assoc "КГ" wellTypes))))
	      wellTopAddon150Height (last (assoc "К-7-1.5" (last (assoc "КГ" wellTypes))))
	      wellTopAddon66Height (last (assoc "КО-660" (last (assoc "КГ" wellTypes))))
	      wellTopHeight (last (assoc wellTop (last (assoc "ОУЭ" wellTypes))))
	      wellBaseTopDepth (- (* wellStructureFullHeight 1000) wellBaseHeight wellBaseTopHeight)
	      wellAddonsHeight (- wellBaseTopDepth wellTopHeight)
	)

;;;	(princ "\n")
;;;  	(princ (strcat "(SetWellParams)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")

)

(defun getAddonsCount (/ startTime)
  
  (setq startTime (getvar "millisecs"))
  
	(setq wellBaseAddon5Count 0
	      wellBaseAddon10Count 0
	      wellTopAddon1000Count 0
	      wellTopAddon500Count 0
	      wellTopAddon150Count 0
	      wellTopAddon66Count 0
	      wellTopAddonsHeight 0)
	

	(if (> wellBaseTopDepth 4000)
	  (setq wellBaseAddonsCountList (getWellBaseAddonsCount
					  (rem wellBaseTopDepth 4000)
					  wellBaseAddon5Count
					  wellBaseAddon10Count)
		wellBaseAddon5Count (car wellBaseAddonsCountList)
		wellBaseAddon10Count (last wellBaseAddonsCountList)
	  )
	  (if (> wellAddonsHeight wellBaseAddon5Height)
	    (setq wellBaseAddon5Count (+ wellBaseAddon5Count 1))
	  )
	)

	(setq wellTopAddonsHeight (- wellAddonsHeight
					     (* wellBaseAddon5Height wellBaseAddon5Count)
					     (* wellBaseAddon10Height wellBaseAddon10Count))
	)

	(setq wellTopAddonsCountList (getWellTopAddonsCount
				       wellTopAddonsHeight
					  wellTopAddon1000Count wellTopAddon500Count
					  wellTopAddon150Count  wellTopAddon66Count)
	      wellTopAddon1000Count (car wellTopAddonsCountList)
	      wellTopAddon500Count (cadr wellTopAddonsCountList)
	      wellTopAddon150Count (caddr wellTopAddonsCountList)
	      wellTopAddon66Count (last wellTopAddonsCountList)
	  )
	
	(setq WellHeight (+ wellBaseHeight
			    (* wellBaseAddon5Height wellBaseAddon5Count)
			    (* wellBaseAddon10Height wellBaseAddon10Count))
	      
	      wellTopAddonsError (- wellTopAddonsHeight
				    (* wellTopAddon1000Height wellTopAddon1000Count)
				    (* wellTopAddon500Height wellTopAddon500Count)
				    (* wellTopAddon150Height wellTopAddon150Count)
;;;				    (* wellTopAddon66Height wellTopAddon66Count)
				 )
	)
  
;;;  	(princ "\n")
;;;  	(princ (strcat "(getAddonsCount)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")

)

(defun setRowData (/ startTime tableColumns)
  (setq startTime (getvar "millisecs"))
  
  	(setq tableColumns 8)
	
	;;(alert (rtos wellAddonsHeight 2))
	
	(vla-InsertRows WellTable tableRows RowHeight 1)

;;;      	(princ "\n")
;;;  	(princ (strcat "(vla-InsertRows)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")

	
	(vla-settext WellTable tableRows 0 wellName)
	
	(vla-settext WellTable tableRows 1
	  (rtos wellRimElevation 2 2))	
	
	(vla-settext WellTable tableRows 2
	  (rtos	wellSumpElevation 2 2 ))
	
	(vla-settext WellTable tableRows 3 (strcat wellType "-"
	    (rtos (* wellStructureInnerDiameterOrWidth 10) 2 0)))
	
	(vla-settext WellTable tableRows 4
	  (rtos wellStructureProfileHeight 2 2))
	
	(vla-settext WellTable tableRows 5 (rtos wellStructureFullHeight 2 2))

	(vla-settext WellTable tableRows 6 (rtos (/ wellTopAddonsHeight 1000) 2 2))

	(vla-settext WellTable tableRows 7 (rtos WellHeight 2 0))

	(foreach wellDiameter wellDiameterList
	  (vla-settext WellTable tableRows tableColumns 1)
	  (vla-settext WellTable tableRows (+ tableColumns 1) wellBaseAddon5Count)
	  (vla-settext WellTable tableRows (+ tableColumns 2) wellBaseAddon10Count)
	  (setq tableColumns (+ tableColumns 3))
	  (vla-settext WellTable tableRows tableColumns 1)
	)
	(setq tableColumns (+ tableColumns 1))
	(vla-settext WellTable tableRows tableColumns wellTopAddon150Count)
	(vla-settext WellTable tableRows (+ tableColumns 1) wellTopAddon500Count)
	(vla-settext WellTable tableRows (+ tableColumns 2) wellTopAddon1000Count)
	(vla-settext WellTable tableRows (+ tableColumns 3) 1)
	(vla-settext WellTable tableRows (+ tableColumns 4) 1)

	(vla-settext WellTable tableRows (+ tableColumns 5) (fix wellTopAddonsError))
	
	(setq tableRows (1+ tableRows))
	(vla-SetTextHeight WellTable acDataRow DataRowHeight)
  
;;;    	(princ "\n")
;;;  	(princ (strcat "(setRowData)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")

)