;;; WellsTable
;;; 
;;; 
;;; (c) BlackHarp

(defun C:WT (/ objSet startTime)
  (vl-load-com)

  (setq netTypeList (list "ВГ" "ВД"))
  (setq wellTopList (list "ОУЭ-СМ-600" "ОУЭ-600"))
  (setq wellTypeAssoc '(("ВГ" "Смотровой")("ВД" "Дождеприемный")))
  
  (setq wellTypes '(("ВГ"
		     (("Type" "Смотровой")("Дно" 0.4)("Лестница" "Л2")
		      ("12" (("Base" 1980)("ЖБ M300" 1.0)
                             ("МБ М300" 0.26)("МБ М300+" 0.0)
                             ("Песок" 0.28)("Битум" 9.02)("Битум+" 4.5)))
		      ("15" (("Base" 1980)("ЖБ M300" 1.4)
                             ("МБ М300" 0.44)("МБ М300+" 0.0)
                             ("Песок" 0.38)("Битум" 10.70)("Битум+" 5.4)))
		      ("20" (("Base" 1980)("ЖБ M300" 2.19)
                             ("МБ М300" 0.97)("МБ М300+" 0.0)
                             ("Песок" 0.60)("Битум" 13.93)("Битум+" 7.0)))
		      ("25" (("Base" 1980)("ЖБ M300" 3.19)
                             ("МБ М300" 1.60)("МБ М300+" 0.0)
                             ("Песок" 0.87)("Битум" 18.76)("Битум+" 9.38)))))
		    ("ВД"
		     (("Type" "Дождеприемный")("Дно" 0.15)
		      ("8" (("Base" 1550)("ПВК-8" 170)("Cетка" 0.34)
		      ("Бетон M200" 0.27)("Песок" 0.11)("Битум" 4.6)("Битум+" 3.65)))))
		    ("ППК"
		     (("Type" "Перепадный")("Дно" 0.7)
		      ("15" (("Base" 1150)("ЖБ M300" 1.4)
                             ("МБ М300" 0.07)("МБ М300+" 0.5)
                             ("Песок" 0.41)("Битум" 4.0)("Битум+" 7.0)))
		      ("20" (("Base" 1190)("ЖБ M300" 2.19)
                             ("МБ М300" 0.1)("МБ М300+" 0.5)
                             ("Песок" 0.50)("Битум" 9.0)("Битум+" 7.0)))))
		    ("КГ"
		     (("Type" "Добор")
		      ("КО-660" 66)
		      ("К-7-1.5" (("Высота" 145)("СК-2" 0)("СК-3" 0)("СК-4" 0)("СК-5" 1)("ГС-1" 3)))
		      ("К-7-5" (("Высота" 490)("СК-2" 1)("СК-3" 1)("СК-4" 0)("СК-5" 1)("ГС-1" 3)))
		      ("К-7-10" (("Высота" 990)("СК-2" 0)("СК-3" 1)("СК-4" 1)("СК-5" 1)("ГС-1" 3)))))
                    ("ПД" (("15" 160)
                           ("20" 200)))
                    ("К" (("5" 490)
                          ("10" 990)))
                    ("ПК" (("8" 170)
                           ("12" 140)
                     	   ("15" 140)
                     	   ("20" 160)
                           ("25" 180)))
		    ("ОУЭ"
		     (("Type" "Люк")
		      ("ОУЭ-600" 140)
		      ("ОУЭ-СМ-600" 200)))
		    )
        ;; well joint materials
        ;; ('diameter' 'monolith concrete M200' 'net type')
        wellJoints '(("<400" 0.11 "С-1" 1.29)
                     ("400" 0.14 "С-1" 1.29)
                     ("500" 0.16 "С-2" 1.53)
                     ("600" 0.15 "С-3" 1.73)
                     ("800" 0.27 "С-4" 2.21)
                     ("1000" 0.38 "С-5" 2.69))
	wellBraceHeight 30
  )
  ;;(setq wellStructureBottom 0.4)
  

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
      (if (setq objSet (ssget '((0 . "AECC_STRUCTURE"))))
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
	  (if (equal (vlax-get wellStyle 'Name) (last (assoc netType wellTypeAssoc)))
	      (progn
		(setq wellDataList (append wellDataList (list (list (cons "Name" (setq currStructName (vlax-get obj 'Name)))
				       (cons "RimElevation" (vlax-get obj 'RimElevation))
				       (cons "PipeLowestBottomDepth" (vlax-get obj 'PipeLowestBottomDepth))
				       (cons "SumpElevation" (vlax-get obj 'SumpElevation))
				       (cons "StructureInnerDiameterOrWidth" (vlax-get obj 'StructureInnerDiameterOrWidth))
				       (cons "ConnectedPipeNames" (setq connectedPipeNames (vlax-get obj 'ConnectedPipeNames)))
				       (cons "ConnectedPipeInnerTopsAndBottoms" (list (getPipeInnerTopsAndBottoms connectedPipeNames)))))
				       
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

(defun getPipeInnerTopAndBottom (pipeName / objSet SelSetLength Entity obj)
  (setq objSet (ssget "X" '((0 . "AECC_PIPE"))))
  (setq SelSetLength 0)
  (while (< SelSetLength (sslength objSet))
  	(setq	Entity (ssname objSet SelSetLength)
		obj    (vlax-ename->vla-object Entity))
    (if (eq (vlax-get obj 'DisplayName) pipeName)
      (progn
	      (setq pipeInnerDiameter (vlax-get obj 'InnerDiameterOrWidth)
	      	    startStructName (vlax-get (vlax-get obj 'StartStructure) 'DisplayName))
	      (if (eq startStructName currStructName)
		(setq pointAtParam 0)
		(setq pointAtParam 1)
	      )
	      (setq pipeMiddle (last (vlax-safearray->list
					  (vlax-variant-value
					    (vlax-get-property obj 'PointAtParam pointAtParam))))
                    pipeInnerTop (+ pipeMiddle  (/ pipeInnerDiameter 2))
		    pipeInnerBottom (- pipeMiddle  (/ pipeInnerDiameter 2)))
	)
    )
    (setq SelSetLength (1+ SelSetLength))
  )
  (list pipeInnerTop pipeInnerBottom)
)

(defun getPipeInnerTopsAndBottoms ( pipeNames / )
  (setq pipeNameList (SplitStr pipeNames ", "))
  (mapcar 'getPipeInnerTopAndBottom pipeNameList)
)

(defun SplitStr ( s d / p )
  (if (setq p (vl-string-search d s))
    (cons (substr s 1 p) (SplitStr (substr s (+ p 1 (strlen d))) d)) (list s)))