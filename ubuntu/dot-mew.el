(setq mew-name "Suguru HAMAZAKI")

(setq mew-config-alist
      '(("default"
	 ("user" . "hamazy")
	 ("proto" . "%")
	 ("mail-domain" . "suguruhamazaki.com")

	 ("smtp-server" . "smtp.gmail.com")
         ("smtp-auth" . t)
         ("smtp-auth-list" . ("CRAM-MD5" "DIGEST-MD5" "PLAIN" "LOGIN"))
	 ("smtp-user" . "hamazy@webspiritus.com")
	 ("smtp-ssl" . t)
	 ("smtp-ssl-port" . "465")

	 ("imap-server" . "imap.gmail.com")
	 ("imap-user" . "hamazy@webspiritus.com")
         ("imap-auth" . t)
         ("imap-auth-list" . ("CRAM-MD5" "DIGEST-MD5" "PLAIN" "LOGIN"))
	 ("imap-ssl" . t)
	 ("imap-ssl-port" . "993")
	 ("imap-delete" . nil)
	 ("signature-file" . "~/.signature")
	 ("fcc". "%Sent"))

	("gmail"
	 ("user" . "yzmhnets")
	 ("proto" . "%")
	 ("mail-domain" . "gmail.com")

	 ("smtp-server" . "smtp.gmail.com")
         ("smtp-auth" . t)
         ("smtp-auth-list" . ("CRAM-MD5" "DIGEST-MD5" "PLAIN" "LOGIN"))
	 ("smtp-user" . "yzmhnets@gmail.com")
	 ("smtp-ssl" . t)
	 ("smtp-ssl-port" . "465")

	 ("imap-server" . "imap.gmail.com")
	 ("imap-user" . "yzmhnets@gmail.com")
         ("imap-auth" . t)
         ("imap-auth-list" . ("CRAM-MD5" "DIGEST-MD5" "PLAIN" "LOGIN"))
	 ("imap-ssl" . t)
	 ("imap-ssl-port" . "993")
	 ("imap-delete" . nil)
	 ("signature-file" . "~/.signature.gmail")
	 ("fcc". "%Sent"))

	("xyzzyx"
	 ("user" . "hamazy")
	 ("proto" . "%")
	 ("mail-domain" . "xyzzyx.co.jp")

	 ("smtp-ssl" . t)
	 ("smtp-server" . "mail.xyzzyx.co.jp")
         ("smtp-auth" . t)
         ("smtp-auth-list" . ("CRAM-MD5" "DIGEST-MD5" "PLAIN" "LOGIN"))
	 ("smtp-user" . "hamazy")
	 ("smtp-ssl-port" . "465")

	 ("imap-ssl" . t)
	 ("imap-ssl-port" . "993")
	 ("imap-server" . "mail.xyzzyx.co.jp")
	 ("imap-user" . "hamazy")
         ("imap-auth"   . ("CRAM-MD5" "DIGEST-MD5" "PLAIN" "LOGIN"))
	 ("imap-delete" . nil)
	 ("signature-file" . "~/.signature.xyzzyx")
	 ("fcc". "%Sent"))))

(setq mew-mime-multipart-alternative-list '("Text/Html" "Text/Plain" "*."))
(condition-case nil
    (require 'mew-w3m)
  (file-error nil))

(setq mew-ask-subject t)

;; For citation
(setq mew-cite-fields '("Date:" "From:"))
(setq mew-cite-format "On %s, %s wrote:\n")

(setq mew-use-unread-mark t)
(setq mew-use-cached-passwd nil)

(setq mew-auto-get nil)
(setq mew-summary-trace-directory nil)
(setq mew-visit-inbox-after-setting-case t)

(add-hook 'mew-draft-mode-newdraft-hook
	    (lambda ()
	          (let ((mew-signature-insert-last t))
		          (mew-draft-insert-signature))))
(add-hook 'mew-before-cite-hook 'mew-header-goto-body)

(add-hook 'mew-summary-mode-hook
          (function (lambda ()
                      (define-key mew-summary-mode-map
                        "\C-h" 'mew-summary-prev-page)
                      )))

;; Refiling rules
(setq mew-refile-guess-alist
      '("From:"
	 ("news@mixi.jp" . "%mixi")
	 ("@twine.*\\.com" . "%twine")
	 ("@.*twitter.*\\.com" . "%twitter")
	 ("logwatch@webspiritus.com" . "%log")
	 ("@.*istockphoto.com" . "%istockphoto")
	 ("@amazon\\.co\\.jp" . "%amazon")
	 ("@green\\\-japan\\.com" . "%recruit")
	 ("@expy\\.jp" . "%jr-west")
	 ("@.*\\mufg\\.jp" . "%ufj")
	 ("@scribd.com" . "%scribd")
	 ("@cs-mail\\.ezweb\\.ne\\.jp" . "%au")
	 ("@.*slidemagnet\\.com" . "%slidemagnet")
	 ("erico111@hotmail\\.com" . "%from/erico")
	 ("@.*apple\\.com" . "%apple")
	 ("@ufjcard\\.com" . "%ufjcard")
	 ("@manning\\.com" . "%manning")
	 ("@manning\\-sandbox\\.com" . "%manning")
	 ("@netbk\\.co\\.jp" . "%netbank")
	 ("@.*coach\\.com" . "%coach")
	 ("@.*smbc\\.co\\.jp" . "%smbc")
	 ("@.*pitapa\\.com" . "%pitapa"))
	("List-ID"
	 ("semantic_web.googlegroups.com" . "%googlegroups.semantic_web")
	 ("sioc-dev.googlegroups.com" . "%googlegroups.sioc-dev")
	 ("javaposse.googlegroups.com" . "%googlegroups.javapose"))
	("X-Redmine-Project"
         ("tigershark" . "%tigershark"))
        ("X-ML-Name"
         ("tigershark-ml" . "%tigershark")
         ("lilith-ml" . "%lilith")
         ("vertigo-ml". "%vertigo")
         ("citizenkane-ml" . "%citizenkane")
         ("rebecca-ml" . "%rebbecca")
         ("rearwindow-ml", "%rearwindow"))
        ("X-GitLab-Project"
         ("skylink-access-android |" . "%tigershark")
         ("skylinkaccess |" . "%tigershark"))))
