;;;
;;; Emacs-BGEX patch convenience functions
;;;




;;
(defvar bgex-id-default nil)
(defvar bgex-initialize-add-hook-p nil)




;; ��������� ɬ�פ� hook �򤷤ޤ���
(defun bgex-initialize-add-hook ()
  (when (not bgex-initialize-add-hook-p)
    (add-hook 'dired-mode-hook
	      (lambda ()
		(define-key dired-mode-map "s" 'bgex-dired-sort-wrapper)))
    (setq bgex-initialize-add-hook-p t)))




(bgex-initialize-add-hook)




;; �ǥե�����طʤ���Ͽ����Ƥ���� Non-nil ���֤��ޤ���
(defun bgex-bgexid-check-default ()
  (let ((list (bgexid-get-bgexid-list)) (i 0) (id))
    (catch 'loop
      (while (setq id (nth i list))
	(let ((ilist (bgexid-get-identifier id)))
	  (when (assq 'bgex-identifier-type-default ilist)
	    (throw 'loop t))
	  (setq i (1+ i))))
      (throw 'loop nil))))


;; ���ꤷ���طʤ���Ͽ����Ƥ���� Non-nil ���֤��ޤ���
(defun bgex-bgexid-check (identifier type)
  (let ((list (bgexid-get-bgexid-list)) (i 0) (id))
    (catch 'loop
      (while (setq id (nth i list))
	(let ((ilist (bgexid-get-identifier id)))
	  (when (and (assq type ilist)
		     (string= (cdr (assq type ilist)) identifier))
	    (throw 'loop id))
	  (setq i (1+ i))))
      (throw 'loop nil))))




;;
(defun bgex-strict ()
  "BGEX �������̩�⡼�ɤˤ��ޤ���
CPU �ȥͥåȥ���Ӱ�����ˤ��ƤǤ�����θ�̩����ͥ�褷�ޤ���
�ǥե���ȤǤϤ��Υ⡼�ɤˤʤ�ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(bgexi-set-draw-strict)
	(redraw-display))
    (message "Emacs is not running under a X window system.")))


(defun bgex-fast ()
  "BGEX ��������®�⡼�ɤˤ��ޤ���
���̤��㴳���뤳�Ȥ�����ޤ���
CPU ��ǽ���㤤����ͥåȥ���ۤ��ǰ������ʤɤ�ͭ���Ǥ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(bgexi-set-draw-fast)
	(redraw-display))
    (message "Emacs is not running under a X window system.")))




;;
(defun bgex-enable ()
  "BGEX ��ͭ���ˤ��ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(bgexi-enable)
	(redraw-display))
    (message "Emacs is not running under a X window system.")))


(defun bgex-disable ()
  "BGEX ��̵�������ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(bgexi-disable)
	(redraw-display)
	(sit-for 0.1)
	(redraw-display))
    (message "Emacs is not running under a X window system.")))




;;
(defun bgex-set-image (identifier type filename &optional dynamic-color-p)
  "������ɥ����Ȥ��طʲ�������ꤷ�ޤ���
identifier �ϥ�����ɥ����̤��뤿���ʸ����ǡ��᥸�㡼�⡼�ɤ�Хåե�̾����ꤷ�ޤ���
type �ˤ�
    'bgex-identifier-type-major-mode	(identifier ��᥸�㡼�⡼��̾�Ȥ��ư���)
    'bgex-identifier-type-buffer-name	(identifier ��Хåե�̾�Ȥ��ư���)
������Ǥ��ޤ���
filename �ˤϲ����ե�����̾����ꤷ�ޤ���
dynamic-color-p �� Non-nil �ʤ��ưŪ�������⡼�ɤǵ�ư���ޤ���"
  (interactive)

  (unless (file-readable-p filename)
    (error "file \"%s\" not found." filename))

  (if (string= window-system "x")
      (progn
	(let ((getid (bgex-bgexid-check identifier type)))
	  (if getid
	      (progn
		(let ((color (bgexi-get-color getid)))
		  (bgexi-restart getid t dynamic-color-p color (expand-file-name filename)))
		(redraw-display)
		getid)
	    (let ((id (bgexid-create identifier type)))
	      (if id
		  (if (bgexi-create id t dynamic-color-p "white" (expand-file-name filename))
		      (message "bgexi-create failed.")
		    (redraw-display)
		    id)
		(error "Internal error."))))))
    (message "Emacs is not running under a X window system.")))


(defun bgex-set-color (identifier type color &optional dynamic-color-p)
  "������ɥ����Ȥ��طʿ�����ꤷ�ޤ���
identifier �ϥ�����ɥ����̤��뤿���ʸ����ǡ��᥸�㡼�⡼�ɤ�Хåե�̾����ꤷ�ޤ���
type �ˤ�
    'bgex-identifier-type-major-mode	(identifier ��᥸�㡼�⡼��̾�Ȥ��ư���)
    'bgex-identifier-type-buffer-name	(identifier ��Хåե�̾�Ȥ��ư���)
������Ǥ��롣
color �ˤϿ�����ꤷ�ޤ�����̾�򤢤�魯ʸ���� '(r g b) �Τ褦�ʥꥹ�Ȥ���ꤷ�ޤ���
r,g,b �������� 0 - 65535 ���ͤ�Ȥ�ޤ���
dynamic-color-p �� Non-nil �ʤ��ưŪ�������⡼�ɤǵ�ư���ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(let ((getid (bgex-bgexid-check identifier type)))
	  (if getid
	      (progn
		(let ((filename (bgexi-get-image-filename getid)))
		  (bgexi-restart getid nil dynamic-color-p color filename))
		(redraw-display)
		getid)
	    (let ((id (bgexid-create identifier type)))
	      (if id
		  (if (bgexi-create id nil dynamic-color-p color nil)
		      (message "bgexi-create failed.")
		    (redraw-display)
		    id)
		(error "Internal error."))))))
    (message "Emacs is not running under a X window system.")))


(defun bgex-destroy (identifier type)
  "���ꤷ���طʤ��˴����ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(let ((getid (bgex-bgexid-check identifier type)))
	  (when getid
	    (bgexid-destroy getid)
	    (redraw-display)
	    getid)))
    (message "Emacs is not running under a X window system.")))


(defun bgex-set-dynamic-color-flag (bgexid flag)
  "���ꤷ���طʤ�ưŪ�������⡼�ɥե饰�����ꤷ�ޤ���
Non-nil �ʤ��ưŪ�������⡼�ɤˤʤ�ޤ���"
  (interactive)

  (redraw-display)
  (bgexi-set-dynamic-color-flag bgexid flag)
  (redraw-display))


(defun bgex-get-dynamic-color-flag (bgexid)
  "���ꤷ���طʤ�ưŪ�������⡼�ɥե饰�����ޤ���"
  (interactive)

  (bgexi-get-dynamic-color-flag bgexid))




;;
(defun bgex-set-image-default (filename &optional dynamic-color-p)
  "�ǥե���Ȥ��طʲ�������ꤷ�ޤ���"
  (interactive)

  (unless (file-readable-p filename)
    (error "file \"%s\" not found." filename))

  (if (string= window-system "x")
      (progn
	(when (and (not (car (nth 0 (bgexid-get-identifier 0))))
		   (or (> (length (bgexid-get-bgexid-list)) 0)
		       (> (length (bgexi-get-bgexid-list)) 0)))
	  (error "Cant set default image."))
	(if (bgex-bgexid-check-default)
	    (progn
	      (let ((color (bgexi-get-color bgex-id-default)))
		(bgexi-restart bgex-id-default t dynamic-color-p color (expand-file-name filename)))
	      (redraw-display)
	      0)
	  (let ((id (bgexid-create nil 'bgex-identifier-type-default)))
	    (if id
		(if (bgexi-create id t dynamic-color-p "white" (expand-file-name filename))
		    (message "bgexi-create failed.")
		  (setq bgex-id-default id)
		  (redraw-display)
		  0)
	      (error "Internal error.")))))
    (message "Emacs is not running under a X window system.")))


(defun bgex-set-color-default (color &optional dynamic-color-p)
  "�ǥե���Ȥ��طʿ�����ꤷ�ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(when (and (not (car (nth 0 (bgexid-get-identifier 0))))
		   (or (> (length (bgexid-get-bgexid-list)) 0)
		       (> (length (bgexi-get-bgexid-list)) 0)))
	  (error "Cant set default color."))
	(if (bgex-bgexid-check-default)
	    (progn
	      (let ((filename (bgexi-get-image-filename bgex-id-default)))
		(bgexi-restart bgex-id-default nil dynamic-color-p color filename))
	      (redraw-display)
	      0)
	  (let ((id (bgexid-create nil 'bgex-identifier-type-default)))
	    (if id
		(if (bgexi-create id nil dynamic-color-p color nil)
		    (message "bgexi-create failed.")
		  (setq bgex-id-default id)
		  (redraw-display)
		  0)
	      (error "Internal error.")))))
    (message "Emacs is not running under a X window system.")))


(defun bgex-destroy-default ()
  "�ǥե���Ȥ��طʤ��˴����ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(if bgex-id-default
	    (progn
	      (bgexid-destroy bgex-id-default)
	      (setq bgex-id-default nil)
	      (redraw-display)
	      0)
	  (message "BGEX is not used.")))
    (message "Emacs is not running under a X window system.")))


(defun bgex-set-dynamic-color-flag-default (flag)
  "�ǥե���Ȥ��طʤ�ưŪ�������⡼�ɥե饰�����ꤷ�ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(redraw-display)
	(bgexi-set-dynamic-color-flag bgex-id-default flag)
	(redraw-display))
    (message "Emacs is not running under a X window system.")))




;;
(defun bgex-destroy-all ()
  "BGEX ���˴����ޤ���"
  (interactive)

  (if (string= window-system "x")
      (progn
	(let ((list (bgexid-get-bgexid-list)) (i 0) (id))
	  (while (setq id (nth i list))
	    (bgexid-destroy id)
	    (setq i (1+ i)))
	  (redraw-display)
	  i))
    (message "Emacs is not running under a X window system.")))




(defun bgex-dired-sort-wrapper (&optional arg)
  (interactive "P")
  (dired-sort-toggle-or-edit arg)
  (bgexi-redraw-window (selected-window)))




;;
(provide 'bgex)
