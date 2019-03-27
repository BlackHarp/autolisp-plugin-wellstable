(defun createWellTable (/ startTime tableRows tableColumns WellTable)
    (defun *error* (msg)
      (princ (strcat "\n createWellTable error : " msg))
      (princ)
      ) ;_ end of defun

  (setvar "REGENMODE" 0)

  (setq insertionPoint (vlax-3d-point (setq Point (getpoint "Where? "))))

  (setq a_app  (vlax-get-acad-object)
        adoc  (vla-get-activedocument a_app)
        a_blks (vla-get-blocks adoc)
        blk    (vla-add a_blks (vlax-3d-point '(0 0 0)) "*U")
        ) ;_ end of setq

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
		    ;;MySpace
                    blk
		    ;; Set Insert Point
		    ;;(vlax-3d-point (setq Point (getpoint "Where? ")))
                    ;;insertionPoint
                    (vlax-3d-point '(0 0 0))
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
  (vla-settext WellTable 2 2 "лотка трубы")
  (vla-settext WellTable 1 3 "Марка колодцa")
  (vla-settext WellTable 1 4 "Н колодцa по проф., м")
  (vla-settext WellTable 1 5 "Н колодцa полная, м")
  (vla-settext WellTable 1 6 "Н горл., м")
  (vla-settext WellTable 1 7 "Рабочая камера")
  (vla-settext WellTable 2 7 "Н, мм")
  (foreach wellDiameter wellDiameterList
    (vla-InsertColumns WellTable tableColumns ColumnWidth 3)
    (vla-MergeCells WellTable 1 1 7 (+ tableColumns 2))
    
    (vla-settext WellTable 2 tableColumns (strcat netType "-" wellDiameter))
    (vla-settext WellTable 2 (+ tableColumns 1) (strcat "К-" wellDiameter "-5"))
    (vla-settext WellTable 2 (+ tableColumns 2) (strcat "К-" wellDiameter "-10"))
    
    (setq tableColumns (+ tableColumns 3))
    
    (vla-InsertColumns WellTable tableColumns ColumnWidth 2)
    (vla-MergeCells WellTable 1 1 tableColumns (+ tableColumns 1))
    (vla-settext WellTable 1 tableColumns "Плиты перекрытия и днища")
    (vla-settext WellTable 2 tableColumns (strcat "ПД-" wellDiameter))
    (vla-settext WellTable 2 (+ tableColumns 1) (strcat "ПК-" wellDiameter))
  )
  (setq tableColumns (+ tableColumns 2))
  (vla-InsertColumns WellTable tableColumns ColumnWidth 4)
  (vla-MergeCells WellTable 1 1 tableColumns (+ tableColumns 3))
  (vla-settext WellTable 1 tableColumns "Кольца горловины (добор)")
  (vla-settext WellTable 2 tableColumns "К-7-1.5")
  (vla-settext WellTable 2 (+ tableColumns 1) "К-7-5")
  (vla-settext WellTable 2 (+ tableColumns 2) "К-7-10")
  (vla-settext WellTable 2 (+ tableColumns 3) "КО-660")

  (setq tableColumns (+ tableColumns 4))
  (vla-InsertColumns WellTable tableColumns ColumnWidth 6)
  (vla-MergeCells WellTable 1 1 tableColumns (+ tableColumns 5))
  (vla-settext WellTable 1 tableColumns "Скобы")
  (vla-settext WellTable 2 tableColumns "СК-2")
  (vla-settext WellTable 2 (+ tableColumns 1) "СК-3")
  (vla-settext WellTable 2 (+ tableColumns 2) "СК-4")
  (vla-settext WellTable 2 (+ tableColumns 3) "СК-5")
  (vla-settext WellTable 2 (+ tableColumns 4) "ГС-1")
  (vla-settext WellTable 2 (+ tableColumns 5) "ГС-3")

  (setq tableColumns (+ tableColumns 6))
  (vla-InsertColumns WellTable tableColumns ColumnWidth 3)
  (vla-MergeCells WellTable 1 2 tableColumns tableColumns)
  (vla-settext WellTable 1 tableColumns (strcat "Опорно-укрывной элемент " wellTop))
  ;;(vla-MergeCells WellTable 1 1 (+ tableColumns 1) (+ tableColumns 2))
  (vla-settext WellTable 1 (+ tableColumns 1) "Лестн.")
  (vla-settext WellTable 2 (+ tableColumns 1) "Л2")
  (vla-MergeCells WellTable 1 2 (+ tableColumns 2) (+ tableColumns 2))
  (vla-settext WellTable 1 (+ tableColumns 2) "Сетка Ф6 AI яч. 150х150, кг")

  (setq tableColumns (+ tableColumns 3))
  (vla-InsertColumns WellTable tableColumns ColumnWidth 4)
  (vla-MergeCells WellTable 1 1 tableColumns (+ tableColumns 3))
  (vla-settext WellTable 1 tableColumns "Материалы")
  (vla-settext WellTable 2 tableColumns "Монол. бетон М200, м3")
  (vla-settext WellTable 2 (+ tableColumns 1) "Монол. бетон М300, м3")
  (vla-settext WellTable 2 (+ tableColumns 2) "Песок, м3")
  (vla-settext WellTable 2 (+ tableColumns 3) "Битум 2 раза, м2")
  
  (setq tableColumns (+ tableColumns 4))
  (vla-InsertColumns WellTable tableColumns ColumnWidth 1)
  (vla-MergeCells WellTable 1 2 tableColumns tableColumns)
  (vla-settext WellTable 1 tableColumns "Остаток")
  
;;;  (princ "\n")
;;;  (princ (strcat "(createTableHeader)....."
;;;		 (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  (princ "\n")

  (setq wellBaseCountTotal 0
        wellBaseBottomCountTotal 0
	wellBaseAddon5CountTotal 0
	wellBaseAddon10CountTotal 0
	wellBaseTopCountTotal 0
	wellTopAddon1000CountTotal 0
	wellTopAddon500CountTotal 0
	wellTopAddon150CountTotal 0
	wellTopAddon66CountTotal 0
	wellTopAddonBrace2CountTotal 0
	wellTopAddonBrace3CountTotal 0
	wellTopAddonBrace4CountTotal 0
	wellTopAddonBrace5CountTotal 0
	wellTopAddonGuide1CountTotal 0
	wellTopHeadCountTotal 0
        wellAddonBrace2CountTotal 0
	wellAddonBrace3CountTotal 0
	wellAddonBrace4CountTotal 0
	wellAddonBrace5CountTotal 0
	wellAddonGuide1CountTotal 0
        wellAddonGuide2CountTotal 0
        wellAddonGuide3CountTotal 0
        wellAddonGuide4CountTotal 0
        wellLadderCountTotal 0
        wellMeshCountTotal 0
        wellJointsConcreteVolumeTotal 0
        wellBaseConcreteVolumeTotal 0
        wellBasementSandVolumeTotal 0
        wellOuterBitumenVolumeTotal 0)
  
  (foreach well wellDataList
      (progn
	(setq wellType netType)
	
	(setWellParams)
	(getAddonsCount)
	(setRowData)
	
	
      )
  )

  (setRowTotal)
  
  (vla-insertblock (vla-get-modelspace adoc)
                   insertionPoint
                   (vla-get-name blk)
                   1.
                   1.
                   1.
                   0.
                   ) ;_ end of vla-InsertBlock
  ;;(setq explodeset (ssadd))
  ;;(ssadd (vlax-vla-object->ename blk) explodeset))
  ;;(vla-explode explodeset)
  ;;(command "_.EXPLODE" (vlax-vla-object->ename (vla-get-name blk)))
  
  ;;(alert (getvar "REGENMODE"))
  (setvar "REGENMODE" 1)
  
  (princ "\n")
  (princ (strcat "(createWellTable)....."
		 (vl-prin1-to-string (- (getvar "millisecs") startTime))))
  (princ "\n")
)

(defun getWellBaseAddonsCount (AddonsHeight BaseAddon5Count BaseAddon10Count /)

  (if (< AddonsHeight wellBaseAddon5Height)
    (progn
      (princ AddonsHeight)
    (setq BaseAddon5Count
	   (+ BaseAddon5Count 1)
    )
    )
    (if (< AddonsHeight wellBaseAddon10Height)
      (progn
        (princ AddonsHeight)
	(setq BaseAddon10Count
	       (+ BaseAddon10Count 1)
	)
      )
	(progn
	  (setq BaseAddonsList	(getWellBaseAddonsCount
		  			(rem AddonsHeight wellBaseAddon10Height)
		  			BaseAddon5Count
		  			BaseAddon10Count)
                BaseAddon5Count (car BaseAddonsList)
                BaseAddon10Count (+ (last BaseAddonsList) 1))
      	)
    )
  )
  (princ (list BaseAddon5Count BaseAddon10Count))
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
;;;  (princ "\n" )
;;;  (princ  TopAddon1000Count)
  
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon500Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon500Count
			   (+ TopAddon500Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon500Height TopAddon500Count)
			   )
    )
  )
;;;  (princ "\n" )
;;;  (princ  TopAddon500Count)
  
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon150Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon150Count (+ TopAddon150Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon150Height TopAddon150Count)
			   )
    )
  )
;;;  (princ "\n" )
;;;  (princ  TopAddon150Count)
  
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon66Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon66Count (+ TopAddon66Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon66Height TopAddon66Count)
			   )
    )
  )
;;;  (princ "\n" )
;;;  (princ  TopAddon66Count)
  
  (list	TopAddon1000Count
	TopAddon500Count
	TopAddon150Count
	TopAddon66Count
  )
)

(defun setWellParams (/ startTime wellData)
  	(setq startTime (getvar "millisecs"))

  	(setq wellName (cdr (assoc "Name" well))
	      wellRimElevation (cdr (assoc "RimElevation" well))
	      wellSumpElevation (cdr (assoc "SumpElevation" well))
	      wellPipeLowestBottomDepth (cdr (assoc "PipeLowestBottomDepth" well))
	      wellStructureInnerDiameterOrWidth (cdr (assoc "StructureInnerDiameterOrWidth" well))
              topBottomList (cadr (assoc "ConnectedPipeInnerTopsAndBottoms" well)))

  	(setq pipesTopList (mapcar 'car topBottomList)
              pipesBottomList (mapcar 'last topBottomList))

  	(setq maxPipeTop (apply 'max pipesTopList)
              minPipeBottom (apply 'min pipesBottomList)
	      maxPipeBottom (apply 'max pipesBottomList)
	      diff (- maxPipeBottom minPipeBottom))
  
  	(if (< diff 0.7)
	  (setq wellType netType
                TopDepth 4000)
	  (setq wellType "ППК"
                TopDepth (* (- wellRimElevation maxPipeTop 0.5) 1000))
	)

	(setq wellStructureInnerDiameter (rtos (* wellStructureInnerDiameterOrWidth 10) 2 0)
	      wellStructureProfileHeight (- wellRimElevation wellSumpElevation)
              wellData (last (assoc wellType wellTypes))
	      wellStructureBottom (last (assoc "Дно" wellData))
	      wellStructureFullHeight (+ wellStructureProfileHeight wellStructureBottom)
	      wellBaseHeight (+ (last (assoc "Base" (last (assoc wellStructureInnerDiameter wellData))))
				wellBraceHeight)
	      wellBaseAddon5Height (+ (last (assoc "5" (last (assoc "К" wellTypes))))
				      wellBraceHeight)
	      wellBaseAddon10Height (+ (last (assoc "10" (last (assoc "К" wellTypes))))
				       wellBraceHeight)
	      wellBaseTopHeight (last (assoc wellStructureInnerDiameter
					  (last (assoc "ПК" wellTypes))))
              wellBaseConcreteVolume (last (assoc "МБ М300" (last (assoc wellStructureInnerDiameter wellData))))
              wellBasementSandVolume (last (assoc "Песок" (last (assoc wellStructureInnerDiameter wellData))))
              wellBaseBitumenVolume (last (assoc "Битум" (last (assoc wellStructureInnerDiameter wellData))))
              wellBaseAddonBitumenVolume (last (assoc "Битум+" (last (assoc wellStructureInnerDiameter wellData))))
	      wellTopAddon1000 (last (assoc "К-7-10" (last (assoc "КГ" wellTypes))))
	      wellTopAddon1000Height (+ (cadar wellTopAddon1000) wellBraceHeight)
	      wellTopAddon1000Brace2 (last (assoc "СК-2" wellTopAddon1000))
	      wellTopAddon1000Brace3 (last (assoc "СК-3" wellTopAddon1000))
	      wellTopAddon1000Brace4 (last (assoc "СК-4" wellTopAddon1000))
	      wellTopAddon1000Brace5 (last (assoc "СК-5" wellTopAddon1000))
	      wellTopAddon1000Guide1 (last (assoc "ГС-1" wellTopAddon1000))
	      
	      wellTopAddon500 (last (assoc "К-7-5" (last (assoc "КГ" wellTypes))))
	      wellTopAddon500Height (+ (cadar wellTopAddon500) wellBraceHeight)
	      wellTopAddon500Brace2 (last (assoc "СК-2" wellTopAddon500))
	      wellTopAddon500Brace3 (last (assoc "СК-3" wellTopAddon500))
	      wellTopAddon500Brace4 (last (assoc "СК-4" wellTopAddon500))
	      wellTopAddon500Brace5 (last (assoc "СК-5" wellTopAddon500))
	      wellTopAddon500Guide1 (last (assoc "ГС-1" wellTopAddon500))
	      
	      wellTopAddon150 (last (assoc "К-7-1.5" (last (assoc "КГ" wellTypes))))
	      wellTopAddon150Height (+ (cadar wellTopAddon150) wellBraceHeight)
	      wellTopAddon150Brace2 (last (assoc "СК-2" wellTopAddon150))
	      wellTopAddon150Brace3 (last (assoc "СК-3" wellTopAddon150))
	      wellTopAddon150Brace4 (last (assoc "СК-4" wellTopAddon150))
	      wellTopAddon150Brace5 (last (assoc "СК-5" wellTopAddon150))
	      wellTopAddon150Guide1 (last (assoc "ГС-1" wellTopAddon150))
	      
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

  (defun *error* (msg)
      (princ (strcat "\n getAddonsCount error : " msg))
      (princ)
      ) ;_ end of defun

  
  (setq startTime (getvar "millisecs"))

  	(if (eq wellType "ППК")
          (setq wellBaseBottomCount 1
                wellBaseAddon10Count 1
                wellLadderCount 0)
          (setq wellBaseBottomCount 0
                wellBaseAddon10Count 0
                wellLadderCount 1)
        )
  
	(setq wellBaseAddon5Count 0
              wellBaseTopCount 1
              wellBaseAddonBrace3Count 0
              wellBaseAddonBrace4Count 0
              wellBaseAddonGuide3Count 0
              wellBaseAddonGuide4Count 0
	      wellTopAddon1000Count 0
	      wellTopAddon500Count 0
	      wellTopAddon150Count 0
	      wellTopAddon66Count 0
	      wellTopAddonBrace2Count 0
	      wellTopAddonBrace3Count 0
	      wellTopAddonBrace4Count 0
	      wellTopAddonBrace5Count 0
	      wellTopAddonGuide1Count 0
	      wellTopAddonsHeight 0
              wellAddonBrace2Count 0
              wellAddonBrace3Count 0
              wellAddonBrace4Count 0
              wellAddonBrace5Count 0
              wellAddonGuide1Count 0
              wellAddonGuide2Count 0
              wellAddonGuide3Count 0
              wellAddonGuide4Count 0
              wellMeshCount 0
              wellJointsConcreteVolume 0
              
              wellOuterBitumenVolume 0)
	

	(if (> wellBaseTopDepth TopDepth)
	  (setq wellBaseAddonsCountList (getWellBaseAddonsCount
					  ;;(rem wellBaseTopDepth TopDepth)
                                          (- wellBaseTopDepth TopDepth)
					  wellBaseAddon5Count
					  wellBaseAddon10Count)
		wellBaseAddon5Count (car wellBaseAddonsCountList)
		wellBaseAddon10Count (last wellBaseAddonsCountList)
	  )
	  (if (> wellAddonsHeight wellBaseAddon5Height)
	    (setq wellBaseAddon5Count (+ wellBaseAddon5Count 1))
	  )
	)

  	(if (> wellBaseAddon10Count 5)
  	  (setq wellBaseTopCount (1+ wellBaseTopCount))
        )
	(if (> wellBaseAddon10Count 3)
  	  (setq wellBaseTopCount (1+ wellBaseTopCount))
        )

  	(setq wellBaseAddonBrace2Count (+ wellBaseAddon5Count (if (> wellBaseAddon10Count 0) wellLadderCount 0))
              wellBaseAddonBrace3Count (+ wellBaseAddon10Count (- wellBaseAddon5Count (if (> wellBaseAddon5Count 0) wellLadderCount 0)))
              wellBaseAddonBrace4Count (- wellBaseAddon10Count (if (> wellBaseAddon10Count 0) wellLadderCount 0))
	      wellBaseAddonGuide3Count (* (if (> wellBaseAddon10Count 0) (- wellBaseAddon10Count wellBaseTopCount) 0)  3)
              wellBaseAddonGuide4Count wellBaseAddonGuide3Count)
  
        (if (eq wellType "ППК")      
	  (setq wellTopAddonsHeight (- wellAddonsHeight
					     (* wellBaseAddon5Height wellBaseAddon5Count)
					     (* wellBaseAddon10Height (1- wellBaseAddon10Count))))
          (setq wellTopAddonsHeight (- wellAddonsHeight
					     (* wellBaseAddon5Height wellBaseAddon5Count)
					     (* wellBaseAddon10Height wellBaseAddon10Count)))
	)
	(princ wellTopAddonsHeight)
	(setq wellTopAddonsCountList (getWellTopAddonsCount
				       wellTopAddonsHeight
					  wellTopAddon1000Count wellTopAddon500Count
					  wellTopAddon150Count  wellTopAddon66Count)
	      wellTopAddon1000Count (car wellTopAddonsCountList)
	      wellTopAddon500Count (cadr wellTopAddonsCountList)
	      wellTopAddon150Count (caddr wellTopAddonsCountList)
	      wellTopAddon66Count (last wellTopAddonsCountList)
	  )

	(setq wellTopAddonBrace5Count 1
	      wellTopAddonBrace2Count (+ (* wellTopAddon150Count wellTopAddon150Brace2)
					 (* wellTopAddon500Count wellTopAddon500Brace2)
					 (* wellTopAddon1000Count wellTopAddon1000Brace2))
	      wellTopAddonBrace3Count (+ (* wellTopAddon150Count wellTopAddon150Brace3)
					 (* wellTopAddon500Count wellTopAddon500Brace3)
					 (* wellTopAddon1000Count wellTopAddon1000Brace3))
	      wellTopAddonBrace4Count (+ (* wellTopAddon150Count wellTopAddon150Brace4)
					 (* wellTopAddon500Count wellTopAddon500Brace4)
					 (* wellTopAddon1000Count wellTopAddon1000Brace4))
	      wellTopAddonGuide1Count (- (+ (* wellTopAddon150Count wellTopAddon150Guide1)
					 (* wellTopAddon500Count wellTopAddon500Guide1)
					 (* wellTopAddon1000Count wellTopAddon1000Guide1))
					 3)
	  )
	(if (= wellTopAddon150Count 0)
	  (setq wellTopAddonBrace2Count (- wellTopAddonBrace2Count 1))
	  )
  
  	(if (eq wellType "ППК")
	  (setq WellHeight (+ wellBaseHeight
			    (* wellBaseAddon5Height wellBaseAddon5Count)
			    (* wellBaseAddon10Height (1- wellBaseAddon10Count))))
          (setq WellHeight (+ wellBaseHeight
			    (* wellBaseAddon5Height wellBaseAddon5Count)
			    (* wellBaseAddon10Height wellBaseAddon10Count)))
        )

  	;;(if (eq wellType "ППК")
          (setq wellOuterBitumenVolume (+ wellBaseBitumenVolume
                                          (* wellBaseAddon5Count wellBaseAddonBitumenVolume 0.5)
                                          (* wellBaseAddon10Count wellBaseAddonBitumenVolume)))
          
        ;;)
  
	(setq wellTopAddonsError (- wellTopAddonsHeight
				    (* wellTopAddon1000Height wellTopAddon1000Count)
				    (* wellTopAddon500Height wellTopAddon500Count)
				    (* wellTopAddon150Height wellTopAddon150Count)
;;;				    (* wellTopAddon66Height wellTopAddon66Count)
				 )
	)

  	(setq wellAddonBrace2Count (+ wellTopAddonBrace2Count wellBaseAddonBrace2Count)
              wellAddonBrace3Count (+ wellTopAddonBrace3Count wellBaseAddonBrace3Count)
              wellAddonBrace4Count (+ wellTopAddonBrace4Count wellBaseAddonBrace4Count)
              wellAddonBrace5Count wellTopAddonBrace5Count
              wellAddonGuide1Count wellTopAddonGuide1Count
              wellAddonGuide2Count 0
              wellAddonGuide3Count wellBaseAddonGuide3Count
              wellAddonGuide4Count wellBaseAddonGuide4Count)
  
;;;  	(princ "\n")
;;;  	(princ (strcat "(getAddonsCount)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")

)

(defun setRowData (/ startTime tableColumns)

    (defun *error* (msg)
      (princ (strcat "\n setRowData error : " msg))
      (princ)
      ) ;_ end of defun

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
          (if (eq wellType "ППК")
            (progn
              (vla-settext WellTable tableRows tableColumns "-")
              ;;(setq wellBaseAddon10Count (1+ wellBaseAddon10Count))
            )
            (progn
	      (vla-settext WellTable tableRows tableColumns 1)
	      (setq wellBaseCountTotal (1+ wellBaseCountTotal))
            )
          )
	  (vla-settext WellTable tableRows (+ tableColumns 1) (ifZeroSetDash wellBaseAddon5Count))
	  (if (> wellBaseAddon5Count 0) (setq wellBaseAddon5CountTotal (+ wellBaseAddon5CountTotal wellBaseAddon5Count)))
	  (vla-settext WellTable tableRows (+ tableColumns 2) (ifZeroSetDash wellBaseAddon10Count))
	  (if (> wellBaseAddon10Count 0) (setq wellBaseAddon10CountTotal (+ wellBaseAddon10CountTotal wellBaseAddon10Count)))
          
	  (setq tableColumns (+ tableColumns 3))
          (if (eq wellType "ППК")
            (progn
              (vla-settext WellTable tableRows tableColumns wellBaseBottomCount)
	      (setq wellBaseBottomCountTotal (1+ wellBaseBottomCountTotal))
            )
            (vla-settext WellTable tableRows tableColumns "-")
          )
	  (vla-settext WellTable tableRows (+ tableColumns 1) wellBaseTopCount)
	  (setq wellBaseTopCountTotal (1+ wellBaseTopCountTotal))
	)
	(setq tableColumns (+ tableColumns 2))
	(vla-settext WellTable tableRows tableColumns (ifZeroSetDash wellTopAddon150Count))
  	(if (> wellTopAddon150Count 0) (setq wellTopAddon150CountTotal (+ wellTopAddon150CountTotal wellTopAddon150Count)))
	(vla-settext WellTable tableRows (+ tableColumns 1) (ifZeroSetDash wellTopAddon500Count))
  	(if (> wellTopAddon500Count 0) (setq wellTopAddon500CountTotal (+ wellTopAddon500CountTotal wellTopAddon500Count)))
	(vla-settext WellTable tableRows (+ tableColumns 2) (ifZeroSetDash wellTopAddon1000Count))
  	(if (> wellTopAddon1000Count 0) (setq wellTopAddon1000CountTotal (+ wellTopAddon1000CountTotal wellTopAddon1000Count)))
	(vla-settext WellTable tableRows (+ tableColumns 3) 1)
  	(setq wellTopAddon66CountTotal (1+ wellTopAddon66CountTotal))
  
        (setq tableColumns (+ tableColumns 4))
  	(vla-settext WellTable tableRows tableColumns (ifZeroSetDash wellAddonBrace2Count))
        (if (> wellAddonBrace2Count 0) (setq wellAddonBrace2CountTotal (+ wellAddonBrace2CountTotal wellAddonBrace2Count)))
  	(vla-settext WellTable tableRows (+ tableColumns 1) (ifZeroSetDash wellAddonBrace3Count))
  	(if (> wellAddonBrace3Count 0) (setq wellAddonBrace3CountTotal (+ wellAddonBrace3CountTotal wellAddonBrace3Count)))
  	(vla-settext WellTable tableRows (+ tableColumns 2) (ifZeroSetDash wellAddonBrace4Count))
  	(if (> wellAddonBrace4Count 0) (setq wellAddonBrace4CountTotal (+ wellAddonBrace4CountTotal wellAddonBrace4Count)))
  	(vla-settext WellTable tableRows (+ tableColumns 3) (ifZeroSetDash wellAddonBrace5Count))
  	(if (> wellAddonBrace5Count 0) (setq wellAddonBrace5CountTotal (+ wellAddonBrace5CountTotal wellAddonBrace5Count)))
  	(vla-settext WellTable tableRows (+ tableColumns 4) (ifZeroSetDash wellAddonGuide1Count))
  	(if (> wellAddonGuide1Count 0) (setq wellAddonGuide1CountTotal (+ wellAddonGuide1CountTotal wellAddonGuide1Count)))
  	(vla-settext WellTable tableRows (+ tableColumns 5) (ifZeroSetDash wellAddonGuide3Count))
  	(if (> wellAddonGuide3Count 0) (setq wellAddonGuide3CountTotal (+ wellAddonGuide3CountTotal wellAddonGuide3Count)))

  	(setq tableColumns (+ tableColumns 6))
	(vla-settext WellTable tableRows tableColumns 1)
  	(setq wellTopHeadCountTotal (1+ wellTopHeadCountTotal))
  	(vla-settext WellTable tableRows (+ tableColumns 1) (ifZeroSetDash wellLadderCount))
  	(if (> wellLadderCount 0) (setq wellLadderCountTotal (+ wellLadderCountTotal wellLadderCount)))
  
  	(setq tableColumns (+ tableColumns 3))
  	(vla-settext WellTable tableRows (+ tableColumns 1) (ifZeroSetDash wellBaseConcreteVolume))
  	(if (> wellBaseConcreteVolume 0) (setq wellBaseConcreteVolumeTotal (+ wellBaseConcreteVolumeTotal wellBaseConcreteVolume)))
  	(vla-settext WellTable tableRows (+ tableColumns 2) (ifZeroSetDash wellBasementSandVolume))
  	(if (> wellBasementSandVolume 0) (setq wellBasementSandVolumeTotal (+ wellBasementSandVolumeTotal wellBasementSandVolume)))
  	(vla-settext WellTable tableRows (+ tableColumns 3) (ifZeroSetDash wellOuterBitumenVolume))
  	(if (> wellOuterBitumenVolume 0) (setq wellOuterBitumenVolumeTotal (+ wellOuterBitumenVolumeTotal wellOuterBitumenVolume)))
  
	(setq tableColumns (+ tableColumns 4))
	(vla-settext WellTable tableRows tableColumns (fix wellTopAddonsError))
	
	(setq tableRows (1+ tableRows))
	(vla-SetTextHeight WellTable acDataRow DataRowHeight)
  
;;;    	(princ "\n")
;;;  	(princ (strcat "(setRowData)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")

)

(defun setRowTotal (/)
  (defun *error* (msg)
    (princ (strcat "\n setRowTotal error : " msg))
    (princ)
  ) ;_ end of defun

  (vla-InsertRows WellTable tableRows RowHeight 1)
  (vla-MergeCells WellTable tableRows tableRows 0 6)
  (vla-settext WellTable tableRows 0 "Итого")
  (vla-settext WellTable tableRows 7 "-")
  (vla-settext WellTable tableRows 8 wellBaseCountTotal)
  (vla-settext WellTable tableRows 9 wellBaseAddon5CountTotal)
  (vla-settext WellTable tableRows 10 wellBaseAddon10CountTotal)
  (vla-settext WellTable tableRows 11 wellBaseBottomCountTotal)
  (vla-settext WellTable tableRows 12 wellBaseTopCountTotal) 
  (vla-settext WellTable tableRows 13 wellTopAddon150CountTotal)
  (vla-settext WellTable tableRows 14 wellTopAddon500CountTotal)
  (vla-settext WellTable tableRows 15 wellTopAddon1000CountTotal)
  (vla-settext WellTable tableRows 16 wellTopAddon66CountTotal)
  (vla-settext WellTable tableRows 17 wellAddonBrace2CountTotal)
  (vla-settext WellTable tableRows 18 wellAddonBrace3CountTotal)
  (vla-settext WellTable tableRows 19 wellAddonBrace4CountTotal)
  (vla-settext WellTable tableRows 20 wellAddonBrace5CountTotal)
  (vla-settext WellTable tableRows 21 wellAddonGuide1CountTotal)
  (vla-settext WellTable tableRows 22 wellAddonGuide3CountTotal)
  (vla-settext WellTable tableRows 23 wellTopHeadCountTotal)
  (vla-settext WellTable tableRows 24 wellLadderCountTotal)
  (vla-settext WellTable tableRows 25 wellMeshCountTotal)
  (vla-settext WellTable tableRows 26 wellJointsConcreteVolumeTotal)
  (vla-settext WellTable tableRows 27 wellBaseConcreteVolumeTotal)
  (vla-settext WellTable tableRows 28 wellBasementSandVolumeTotal)
  (vla-settext WellTable tableRows 29 wellOuterBitumenVolumeTotal)
)

(defun ifZeroSetDash (value /)
  (if (<= value 0) "-" value)
)