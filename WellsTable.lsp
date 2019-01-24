;;; WellsSelect
;;; 
;;; 
;;; (c) BlackHarp

(defun C:WT (/ objSet startTime)
  (vl-load-com)

  (setq wellTypeList (list "ВГ" "ДК"))
  (setq wellTopList (list "ОУЭ-СМ-600" "ОУЭ-600"))
  (setq wellTypeAssoc '(("ВГ" "Смотровой")("ДК" "Дождеприемный")))
  
  (setq wellTypes '(("ВГ"
		     (("Type" "Смотровой")
		      ("ВГ-12" 1980)("К-12-10" 990)("К-12-5" 490)("ПК-12" 140)
		      ("ВГ-15" 1980)("К-15-10" 990)("К-15-5" 490)("ПК-15" 140)
		      ("ВГ-20" 1980)("К-20-10" 990)("К-20-5" 490)("ПК-20" 160)
		      ("ВГ-25" 1980)("ПК-25" 180)))
		    ("ДК"
		     (("Type" "Дождеприемный")
		      ("ДК-10" 1270)("К-10-10" 990)("К-10-5" 490)))
		    ("КГ"
		     (("Type" "Добор")
		      ("КО-660" 66)("К-7-1.5" 145)("К-7-5" 495)("К-7-10" 990)))
		    ("ОУЭ"
		     (("Type" "Люк")
		      ("ОУЭ-600" 140)
		      ("ОУЭ-СМ-600" 200)))
		    )
  )
  (setq wellStructureBottom 0.4)
  

  ;;(setq localPath "c:/Users/User/Documents/2018 12 Civil Колодцы/")

  (load "createDCL")
  (load "createWellTable")

  (createDCL)

  (if (= dlg_res 0)
    (alert "Отмена")
    (progn

      (setq MySpace (vla-get-ModelSpace
		      (vla-get-ActiveDocument
			(vlax-get-Acad-Object)
		      )
		    )
      )

      (setq TitleHeight 15.0)
      (setq RowHeight 6.0)
      (setq ColumnWidth 20.0)
      (setq TitleRowHeight 5.0)
      (setq HeaderRowHeight 3.0)
      (setq DataRowHeight 3.0)

      
      
      (princ "\n*** Select objects and press Enter *** ")
      (if (setq objSet (ssget '((0 . "AECC_STRUCTURE") (8 . "К2_План"))))
	(progn

	  (setq startTime (getvar "millisecs"))
	  
	(setq wellDataList (list))
	(setq wellDiameterList (list))
	(setq SelSetLength 0)
	(while (< SelSetLength (sslength objSet))
	  (setq	Entity (ssname objSet SelSetLength)
		obj    (vlax-ename->vla-object Entity)
	  )
	  (setq wellStyle (vlax-get obj 'Style))
	  (if (equal (vlax-get wellStyle 'Name) (last (assoc wellType wellTypeAssoc)))
	      (progn
		(setq wellDataList (append wellDataList (list (list (cons "Name" (vlax-get obj 'Name))
				       (cons "RimElevation" (vlax-get obj 'RimElevation))
				       (cons "PipeLowestBottomDepth" (vlax-get obj 'PipeLowestBottomDepth))
				       (cons "SumpElevation" (vlax-get obj 'SumpElevation))
				       (cons "StructureInnerDiameterOrWidth" (vlax-get obj 'StructureInnerDiameterOrWidth))))
		                   )
		)
		(setq StructureInnerDiameter (rtos (* (vlax-get obj 'StructureInnerDiameterOrWidth) 10) 2 0))
		(if (not (member StructureInnerDiameter wellDiameterList))
		  (setq wellDiameterList (append wellDiameterList  (list StructureInnerDiameter)))
		)
	      )
	  )
	  (setq SelSetLength (1+ SelSetLength))
	)
	(setq wellDataList (vl-sort wellDataList
             (function (lambda (e1 e2)
                         (< (cdar e1) (cdar e2)))))
	)
	
	(princ "\n")
        (princ (strcat "(wellDataList)....."
		       (vl-prin1-to-string (- (getvar "millisecs") startTime))))
	(princ "\n")

	;;(princ wellDataList)
	;;(alert wellDataList)
	;; Insert table object
	(createWellTable)
	);;progn
      );; if
    );; progn
  );; if
  (princ "DONE!")
  (princ)
);; C:3DZ

