;;; WellsTable
;;; 
;;; 
;;; (c) BlackHarp

(defun C:WT (/ objSet startTime)
  (vl-load-com)

  (setq netTypeList (list "��" "��"))
  (setq wellTopList (list "���-��-600" "���-600"))
  (setq wellTypeAssoc '(("��" "���������")("��" "�������������")))
  
  (setq wellTypes '(("��"
		     (("Type" "���������")("���" 0.4)("��������" "�2")
		      ("12" (("Base" 1980)("�� M300" 1.0)
                             ("�� �300" 0.26)("�� �300+" 0.0)
                             ("�����" 0.28)("�����" 9.02)("�����+" 4.5)))
		      ("15" (("Base" 1980)("�� M300" 1.4)
                             ("�� �300" 0.44)("�� �300+" 0.0)
                             ("�����" 0.38)("�����" 10.70)("�����+" 5.4)))
		      ("20" (("Base" 1980)("�� M300" 2.19)
                             ("�� �300" 0.97)("�� �300+" 0.0)
                             ("�����" 0.60)("�����" 13.93)("�����+" 7.0)))
		      ("25" (("Base" 1980)("�� M300" 3.19)
                             ("�� �300" 1.60)("�� �300+" 0.0)
                             ("�����" 0.87)("�����" 18.76)("�����+" 9.38)))))
		    ("��"
		     (("Type" "�������������")("���" 0.15)
		      ("8" (("Base" 1550)("���-8" 170)("C����" 0.34)
		      ("����� M200" 0.27)("�����" 0.11)("�����" 4.6)("�����+" 3.65)))))
		    ("���"
		     (("Type" "����������")("���" 0.7)
		      ("15" (("Base" 1150)("�� M300" 1.4)
                             ("�� �300" 0.07)("�� �300+" 0.5)
                             ("�����" 0.41)("�����" 4.0)("�����+" 7.0)))
		      ("20" (("Base" 1190)("�� M300" 2.19)
                             ("�� �300" 0.1)("�� �300+" 0.5)
                             ("�����" 0.50)("�����" 9.0)("�����+" 7.0)))))
		    ("��"
		     (("Type" "�����")
		      ("��-660" 66)
		      ("�-7-1.5" (("������" 145)("��-2" 0)("��-3" 0)("��-4" 0)("��-5" 1)("��-1" 3)))
		      ("�-7-5" (("������" 490)("��-2" 1)("��-3" 1)("��-4" 0)("��-5" 1)("��-1" 3)))
		      ("�-7-10" (("������" 990)("��-2" 0)("��-3" 1)("��-4" 1)("��-5" 1)("��-1" 3)))))
                    ("��" (("15" 160)
                           ("20" 200)))
                    ("�" (("5" 490)
                          ("10" 990)))
                    ("��" (("8" 170)
                           ("12" 140)
                     	   ("15" 140)
                     	   ("20" 160)
                           ("25" 180)))
		    ("���"
		     (("Type" "���")
		      ("���-600" 140)
		      ("���-��-600" 200)))
		    )
        ;; well joint materials
        ;; ('diameter' 'monolith concrete M200' 'net type')
        wellJoints '(("<400" 0.11 "�-1" 1.29)
                     ("400" 0.14 "�-1" 1.29)
                     ("500" 0.16 "�-2" 1.53)
                     ("600" 0.15 "�-3" 1.73)
                     ("800" 0.27 "�-4" 2.21)
                     ("1000" 0.38 "�-5" 2.69))
	wellBraceHeight 30
  )
  ;;(setq wellStructureBottom 0.4)
  

  ;;(setq localPath "c:/Users/User/Documents/2018 12 Civil �������/")

  (load "createDCL")
  (load "createWellTable")

  (createDCL)

  (if (= dlg_res 0)
    (alert "������")
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