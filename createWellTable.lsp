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
        wellJointsMeshCountTotal 0
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
    
    (if (or (eq BaseAddon10Count 4) (eq BaseAddon10Count 6))
        (progn
            (- AddonsHeight wellBaseTopHeight)
            (setq wellBaseTopCount (1+ wellBaseTopCount))))

  (if (< AddonsHeight wellBaseAddon5Height)
    (progn
      (princ AddonsHeight)
      (if (or (eq BaseAddon10Count 3) (eq BaseAddon10Count 5))
        (progn
            (- AddonsHeight wellBaseTopHeight)
            (setq wellBaseTopCount (1+ wellBaseTopCount))))
      (setq BaseAddon5Count  (1+ BaseAddon5Count))
    )
    (if (< AddonsHeight wellBaseAddon10Height)
      (progn
        (princ AddonsHeight)
	(setq BaseAddon10Count (1+ BaseAddon10Count))
      )
      (progn
	  (setq BaseAddonsList	(getWellBaseAddonsCount
		  			(- AddonsHeight wellBaseAddon10Height)
		  			BaseAddon5Count
		  			(1+ BaseAddon10Count))
                BaseAddon5Count (car BaseAddonsList)
                BaseAddon10Count (last BaseAddonsList))
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
  (princ "\n" )
  (princ  TopAddon1000Count)
  
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon500Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon500Count
			   (+ TopAddon500Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon500Height TopAddon500Count)
			   )
    )
  )
  (princ "\n" )
  (princ  TopAddon500Count)
  
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon150Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon150Count (+ TopAddon150Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon150Height TopAddon150Count)
			   )
    )
  )
  (princ "\n" )
  (princ  TopAddon150Count)
  
  (setq AddonsHeightDiv (fix (/ TopAddonsHeight wellTopAddon66Height)))
  (if (> AddonsHeightDiv 0)
    (setq TopAddon66Count (+ TopAddon66Count AddonsHeightDiv)
	  TopAddonsHeight	   (- TopAddonsHeight
			      (* wellTopAddon66Height TopAddon66Count)
			   )
    )
  )
  (princ "\n" )
  (princ  TopAddon66Count)
  
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
              pipesBottomList (mapcar 'last topBottomList)
              pipesDiameterList (mapcar '(lambda(x) (- (car x) (cadr x))) topBottomList))

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
              wellBaseBottomConcreteVolume (last (assoc "МБ М300" (last (assoc wellStructureInnerDiameter wellData))))
              wellBaseAddonConcreteVolume (last (assoc "МБ М300+" (last (assoc wellStructureInnerDiameter wellData))))
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
    (defun *error* (msg) (princ (strcat "\n getAddonsCount error : " msg)) (princ)) ;_ end of defun
    (setq startTime (getvar "millisecs"))
    (if (eq wellType "ППК")
        (setq wellBaseBottomCount 1
              wellBaseAddon10Count 1
              wellLadderCount 0
        ) ;_ конец setq
        (setq wellBaseBottomCount 0
              wellBaseAddon10Count 0
              wellLadderCount 1
        ) ;_ конец setq
    ) ;_ конец if
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
          wellJointsMeshCount 0
          wellJointsConcreteVolume 0
          wellBaseConcreteVolume 0
          wellOuterBitumenVolume 0
    ) ;_ конец setq
    (if (> wellBaseTopDepth TopDepth)
        (setq wellBaseAddonsCountList (getWellBaseAddonsCount ;;(rem wellBaseTopDepth TopDepth)
                                                              (- wellBaseTopDepth TopDepth)
                                                              wellBaseAddon5Count
                                                              wellBaseAddon10Count
                                      ) ;_ конец getWellBaseAddonsCount
              wellBaseAddon5Count     (car wellBaseAddonsCountList)
              wellBaseAddon10Count    (last wellBaseAddonsCountList)
        ) ;_ конец setq
        (if (> wellAddonsHeight wellBaseAddon5Height)
            (setq wellBaseAddon5Count (+ wellBaseAddon5Count 1))
        ) ;_ конец if
    ) ;_ конец if
;;;    (if (> wellBaseAddon10Count 5)
;;;        (setq wellBaseTopCount (1+ wellBaseTopCount))
;;;    ) ;_ конец if
;;;    (if (> wellBaseAddon10Count 3)
;;;        (setq wellBaseTopCount (1+ wellBaseTopCount))
;;;    ) ;_ конец if
    (setq wellBaseAddonBrace2Count (+ wellBaseAddon5Count
                                      (if (> wellBaseAddon10Count 0)
                                          wellLadderCount
                                          0
                                      ) ;_ конец if
                                   ) ;_ конец +
          wellBaseAddonBrace3Count (+ wellBaseAddon10Count
                                      (- wellBaseAddon5Count
                                         (if (> wellBaseAddon5Count 0)
                                             wellLadderCount
                                             0
                                         ) ;_ конец if
                                      ) ;_ конец -
                                   ) ;_ конец +
          wellBaseAddonBrace4Count (- wellBaseAddon10Count
                                      (if (> wellBaseAddon10Count 0)
                                          wellLadderCount
                                          0
                                      ) ;_ конец if
                                   ) ;_ конец -
          wellBaseAddonGuide3Count (* (if (> wellBaseAddon10Count 0)
                                          (- wellBaseAddon10Count wellBaseTopCount) ;_ конец -
                                          0
                                      ) ;_ конец if
                                      3
                                   ) ;_ конец *
          wellBaseAddonGuide4Count wellBaseAddonGuide3Count
    ) ;_ конец setq
    (if (eq wellType "ППК")
        (setq wellTopAddonsHeight (- wellAddonsHeight
                                     (* wellBaseAddon5Height wellBaseAddon5Count)
                                     (* wellBaseAddon10Height (1- wellBaseAddon10Count))
                                     (* wellBaseTopHeight (1- wellBaseTopCount))
                                  ) ;_ конец -
        ) ;_ конец setq
        (setq wellTopAddonsHeight (- wellAddonsHeight
                                     (* wellBaseAddon5Height wellBaseAddon5Count) ;_ конец *
                                     (* wellBaseAddon10Height wellBaseAddon10Count) ;_ конец *
                                  ) ;_ конец -
        ) ;_ конец setq
    ) ;_ конец if
    (princ wellTopAddonsHeight)
    (setq wellTopAddonsCountList (getWellTopAddonsCount
                                     wellTopAddonsHeight          wellTopAddon1000Count
                                     wellTopAddon500Count         wellTopAddon150Count
                                     wellTopAddon66Count
                                    ) ;_ endgetWellTopAddonsCount
 ;_ конец getWellTopAddonsCount
          wellTopAddon1000Count  (car wellTopAddonsCountList)
          wellTopAddon500Count   (cadr wellTopAddonsCountList)
          wellTopAddon150Count   (caddr wellTopAddonsCountList)
          wellTopAddon66Count    (last wellTopAddonsCountList)
    ) ;_ конец setq
    (setq wellTopAddonBrace5Count 1
          wellTopAddonBrace2Count (+ (* wellTopAddon150Count wellTopAddon150Brace2) ;_ конец *
                                     (* wellTopAddon500Count wellTopAddon500Brace2) ;_ конец *
                                     (* wellTopAddon1000Count wellTopAddon1000Brace2) ;_ конец *
                                  ) ;_ конец +
          wellTopAddonBrace3Count (+ (* wellTopAddon150Count wellTopAddon150Brace3) ;_ конец *
                                     (* wellTopAddon500Count wellTopAddon500Brace3) ;_ конец *
                                     (* wellTopAddon1000Count wellTopAddon1000Brace3) ;_ конец *
                                  ) ;_ конец +
          wellTopAddonBrace4Count (+ (* wellTopAddon150Count wellTopAddon150Brace4) ;_ конец *
                                     (* wellTopAddon500Count wellTopAddon500Brace4) ;_ конец *
                                     (* wellTopAddon1000Count wellTopAddon1000Brace4) ;_ конец *
                                  ) ;_ конец +
          wellTopAddonGuide1Count (- (+ (* wellTopAddon150Count wellTopAddon150Guide1) ;_ конец *
                                        (* wellTopAddon500Count wellTopAddon500Guide1) ;_ конец *
                                        (* wellTopAddon1000Count wellTopAddon1000Guide1) ;_ конец *
                                     ) ;_ конец +
                                     3
                                  ) ;_ конец -
    ) ;_ конец setq
    (if (= wellTopAddon150Count 0)
        (setq wellTopAddonBrace2Count (- wellTopAddonBrace2Count 1))
    ) ;_ конец if
    (if (eq wellType "ППК")
        (setq WellHeight (+ wellBaseHeight
                            (* wellBaseAddon5Height wellBaseAddon5Count)
                            (* wellBaseAddon10Height (1- wellBaseAddon10Count))
                            (* wellBaseTopHeight (1- wellBaseTopCount))
                         ) ;_ конец +
        ) ;_ конец setq
        (setq WellHeight (+ wellBaseHeight
                            (* wellBaseAddon5Height wellBaseAddon5Count)
                            (* wellBaseAddon10Height wellBaseAddon10Count) ;_ конец *
                         ) ;_ конец +
        ) ;_ конец setq
    ) ;_ конец if
    
	(mapcar '(lambda (diam / diameter)
                     (setq diameter (* diam 1000))
                     (cond ((< diameter 300)(setq case "<400"))
                           ((<= diameter 400)(setq case "400"))
                           ((<= diameter 500)(setq case "500"))
                           ((<= diameter 600)(setq case "600"))
                           ((<= diameter 800)(setq case "800"))
                           ((> diameter 800)(setq case "1000")))
                     (setq wellJointsMeshCount (+ wellJointsMeshCount (last (assoc case wellJoints)))
                           wellJointsConcreteVolume (+ wellJointsConcreteVolume (cadr (assoc case wellJoints))))
                     (princ (strcat  "\n Диаметр: " (rtos diameter)
                                     " Сетка: " (rtos wellJointsMeshCount)
                                     " Бетон: " (rtos wellJointsConcreteVolume)))
                 )
	        pipesDiameterList
	) ;_ end mapcar

    
    (setq wellBaseConcreteVolume (+ wellBaseBottomConcreteVolume
                                    (* wellBaseAddon5Count wellBaseAddonConcreteVolume 0.5)
                                    (* wellBaseAddon10Count wellBaseAddonConcreteVolume)
                                 ) ;_ конец +
          wellOuterBitumenVolume (+ wellBaseBitumenVolume
                                    (* wellBaseAddon5Count wellBaseAddonBitumenVolume 0.5) ;_ конец *
                                    (* wellBaseAddon10Count wellBaseAddonBitumenVolume) ;_ конец *
                                 ) ;_ конец +
    ) ;_ конец setq
    (setq wellTopAddonsError (- wellTopAddonsHeight
                                (* wellTopAddon1000Height wellTopAddon1000Count) ;_ конец *
                                (* wellTopAddon500Height wellTopAddon500Count) ;_ конец *
                                (* wellTopAddon150Height wellTopAddon150Count) ;_ конец *
;;;				    (* wellTopAddon66Height wellTopAddon66Count)
                             ) ;_ конец -
    ) ;_ конец setq
    (setq wellAddonBrace2Count (+ wellTopAddonBrace2Count wellBaseAddonBrace2Count) ;_ конец +
          wellAddonBrace3Count (+ wellTopAddonBrace3Count wellBaseAddonBrace3Count) ;_ конец +
          wellAddonBrace4Count (+ wellTopAddonBrace4Count wellBaseAddonBrace4Count) ;_ конец +
          wellAddonBrace5Count wellTopAddonBrace5Count
          wellAddonGuide1Count wellTopAddonGuide1Count
          wellAddonGuide2Count 0
          wellAddonGuide3Count wellBaseAddonGuide3Count
          wellAddonGuide4Count wellBaseAddonGuide4Count
    ) ;_ конец setq
;;;  	(princ "\n")
;;;  	(princ (strcat "(getAddonsCount)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")
) ;_ конец defun


(defun setRowData (/ startTime tableColumns)
    (defun *error* (msg) (princ (strcat "\n setRowData error : " msg)) (princ)) ;_ end of defun
    (setq startTime (getvar "millisecs"))
    (setq tableColumns 8)
    ;;(alert (rtos wellAddonsHeight 2))
    (vla-InsertRows WellTable tableRows RowHeight 1)
;;;      	(princ "\n")
;;;  	(princ (strcat "(vla-InsertRows)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")
    (vla-settext WellTable tableRows 0 wellName)
    (vla-settext WellTable tableRows 1 (rtos wellRimElevation 2 2))
    (vla-settext WellTable tableRows 2 (rtos wellSumpElevation 2 2))
    (vla-settext WellTable
                 tableRows
                 3
                 (strcat wellType "-" (rtos (* wellStructureInnerDiameterOrWidth 10) 2 0))
    ) ;_ конец vla-settext
    (vla-settext WellTable tableRows 4 (rtos wellStructureProfileHeight 2 2))
    (vla-settext WellTable tableRows 5 (rtos wellStructureFullHeight 2 2))
    (vla-settext WellTable tableRows 6 (rtos (/ wellTopAddonsHeight 1000) 2 2))
    (vla-settext WellTable tableRows 7 (rtos WellHeight 2 0))
    (foreach wellDiameter wellDiameterList
        (if (eq wellType "ППК")
            (progn (vla-settext WellTable tableRows tableColumns "-")
                   ;;(setq wellBaseAddon10Count (1+ wellBaseAddon10Count))
            ) ;_ конец progn
            (progn (vla-settext WellTable tableRows tableColumns 1)
                   (setq wellBaseCountTotal (1+ wellBaseCountTotal))
            ) ;_ конец progn
        ) ;_ конец if
        (vla-settext WellTable
                     tableRows
                     (+ tableColumns 1)
                     (ifZeroSetDash wellBaseAddon5Count)
        ) ;_ конец vla-settext
        (if (> wellBaseAddon5Count 0)
            (setq wellBaseAddon5CountTotal (+ wellBaseAddon5CountTotal wellBaseAddon5Count))
        ) ;_ конец if
        (vla-settext WellTable
                     tableRows
                     (+ tableColumns 2)
                     (ifZeroSetDash wellBaseAddon10Count)
        ) ;_ конец vla-settext
        (if (> wellBaseAddon10Count 0)
            (setq wellBaseAddon10CountTotal (+ wellBaseAddon10CountTotal wellBaseAddon10Count))
        ) ;_ конец if
        (setq tableColumns (+ tableColumns 3))
        (if (eq wellType "ППК")
            (progn (vla-settext WellTable tableRows tableColumns wellBaseBottomCount)
                   (setq wellBaseBottomCountTotal (1+ wellBaseBottomCountTotal))
            ) ;_ конец progn
            (vla-settext WellTable tableRows tableColumns "-")
        ) ;_ конец if
        (vla-settext WellTable tableRows (+ tableColumns 1) wellBaseTopCount)
        (setq wellBaseTopCountTotal (1+ wellBaseTopCountTotal))
    ) ;_ конец foreach
    (setq tableColumns (+ tableColumns 2))
    (vla-settext WellTable
                 tableRows
                 tableColumns
                 (ifZeroSetDash wellTopAddon150Count)
    ) ;_ конец vla-settext
    (if (> wellTopAddon150Count 0)
        (setq wellTopAddon150CountTotal (+ wellTopAddon150CountTotal wellTopAddon150Count))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 1)
                 (ifZeroSetDash wellTopAddon500Count)
    ) ;_ конец vla-settext
    (if (> wellTopAddon500Count 0)
        (setq wellTopAddon500CountTotal (+ wellTopAddon500CountTotal wellTopAddon500Count))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 2)
                 (ifZeroSetDash wellTopAddon1000Count)
    ) ;_ конец vla-settext
    (if (> wellTopAddon1000Count 0)
        (setq wellTopAddon1000CountTotal (+ wellTopAddon1000CountTotal wellTopAddon1000Count))
    ) ;_ конец if
    (vla-settext WellTable tableRows (+ tableColumns 3) 1)
    (setq wellTopAddon66CountTotal (1+ wellTopAddon66CountTotal))
    (setq tableColumns (+ tableColumns 4))
    (vla-settext WellTable
                 tableRows
                 tableColumns
                 (ifZeroSetDash wellAddonBrace2Count)
    ) ;_ конец vla-settext
    (if (> wellAddonBrace2Count 0)
        (setq wellAddonBrace2CountTotal (+ wellAddonBrace2CountTotal wellAddonBrace2Count))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 1)
                 (ifZeroSetDash wellAddonBrace3Count)
    ) ;_ конец vla-settext
    (if (> wellAddonBrace3Count 0)
        (setq wellAddonBrace3CountTotal (+ wellAddonBrace3CountTotal wellAddonBrace3Count))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 2)
                 (ifZeroSetDash wellAddonBrace4Count)
    ) ;_ конец vla-settext
    (if (> wellAddonBrace4Count 0)
        (setq wellAddonBrace4CountTotal (+ wellAddonBrace4CountTotal wellAddonBrace4Count))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 3)
                 (ifZeroSetDash wellAddonBrace5Count)
    ) ;_ конец vla-settext
    (if (> wellAddonBrace5Count 0)
        (setq wellAddonBrace5CountTotal (+ wellAddonBrace5CountTotal wellAddonBrace5Count))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 4)
                 (ifZeroSetDash wellAddonGuide1Count)
    ) ;_ конец vla-settext
    (if (> wellAddonGuide1Count 0)
        (setq wellAddonGuide1CountTotal (+ wellAddonGuide1CountTotal wellAddonGuide1Count))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 5)
                 (ifZeroSetDash wellAddonGuide3Count)
    ) ;_ конец vla-settext
    (if (> wellAddonGuide3Count 0)
        (setq wellAddonGuide3CountTotal (+ wellAddonGuide3CountTotal wellAddonGuide3Count))
    ) ;_ конец if
    (setq tableColumns (+ tableColumns 6))
    (vla-settext WellTable tableRows tableColumns 1)
    (setq wellTopHeadCountTotal (1+ wellTopHeadCountTotal))
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 1)
                 (ifZeroSetDash wellLadderCount)
    ) ;_ конец vla-settext
    (if (> wellLadderCount 0)
        (setq wellLadderCountTotal (+ wellLadderCountTotal wellLadderCount))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 2)
                 (ifZeroSetDash wellJointsMeshCount)
    ) ;_ конец vla-settext
    (if (> wellJointsMeshCount 0)
        (setq wellJointsMeshCountTotal (+ wellJointsMeshCountTotal wellJointsMeshCount))
    ) ;_ конец if
    
    (setq tableColumns (+ tableColumns 3))
    (vla-settext WellTable
                 tableRows
                 tableColumns
                 (ifZeroSetDash wellJointsConcreteVolume)
    ) ;_ конец vla-settext
    (if (> wellJointsConcreteVolume 0)
        (setq wellJointsConcreteVolumeTotal (+ wellJointsConcreteVolumeTotal wellJointsConcreteVolume))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 1)
                 (ifZeroSetDash wellBaseConcreteVolume)
    ) ;_ конец vla-settext
    (if (> wellBaseConcreteVolume 0)
        (setq wellBaseConcreteVolumeTotal (+ wellBaseConcreteVolumeTotal wellBaseConcreteVolume))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 2)
                 (ifZeroSetDash wellBasementSandVolume)
    ) ;_ конец vla-settext
    (if (> wellBasementSandVolume 0)
        (setq wellBasementSandVolumeTotal (+ wellBasementSandVolumeTotal wellBasementSandVolume))
    ) ;_ конец if
    (vla-settext WellTable
                 tableRows
                 (+ tableColumns 3)
                 (ifZeroSetDash wellOuterBitumenVolume)
    ) ;_ конец vla-settext
    (if (> wellOuterBitumenVolume 0)
        (setq wellOuterBitumenVolumeTotal (+ wellOuterBitumenVolumeTotal wellOuterBitumenVolume))
    ) ;_ конец if
    (setq tableColumns (+ tableColumns 4))
    (vla-settext WellTable tableRows tableColumns (fix wellTopAddonsError))
    (setq tableRows (1+ tableRows))
    ;;(vla-SetTextHeight WellTable acDataRow DataRowHeight)
;;;    	(princ "\n")
;;;  	(princ (strcat "(setRowData)....."
;;;		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
;;;  	(princ "\n")
) ;_ конец defun


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
  (vla-settext WellTable tableRows 25 wellJointsMeshCountTotal)
  (vla-settext WellTable tableRows 26 wellJointsConcreteVolumeTotal)
  (vla-settext WellTable tableRows 27 wellBaseConcreteVolumeTotal)
  (vla-settext WellTable tableRows 28 wellBasementSandVolumeTotal)
  (vla-settext WellTable tableRows 29 wellOuterBitumenVolumeTotal)
  (vla-SetTextHeight WellTable acDataRow DataRowHeight)
)

(defun ifZeroSetDash (value /)
  (if (<= value 0) "-" value)
)