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

        ("sigfoss"
	 ("user" . "hamazy")
	 ("proto" . "%")
	 ("mail-domain" . "sigfoss.com")

	 ("smtp-server" . "sigfoss.sakura.ne.jp")
         ("smtp-auth" . t)
         ("smtp-auth-list" . ("CRAM-MD5" "DIGEST-MD5" "PLAIN" "LOGIN"))
	 ("smtp-user" . "hamazy@sigfoss.com")
	 ("smtp-ssl" . nil)
	 ("smtp-port" . "587")

	 ("imap-ssl" . t)
	 ("imap-ssl-port" . "993")
	 ("imap-server" . "sigfoss.sakura.ne.jp")
	 ("imap-user" . "hamazy@sigfoss.com")
         ("imap-auth"   . ("CRAM-MD5" "DIGEST-MD5" "PLAIN" "LOGIN"))
	 ("imap-delete" . nil)
	 ("signature-file" . "~/.signature.sigfoss")
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
