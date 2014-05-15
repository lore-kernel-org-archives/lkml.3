Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaEOUy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:54:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38098 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaEOUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:54:26 -0400
Message-ID: <53752981.3040307@infradead.org>
Date: Thu, 15 May 2014 13:54:25 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Paul McQuade <paulmcquad@gmail.com>
Subject: [PATCH 2/4] Documentation: update thunderbird email client settings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul McQuade <paulmcquad@gmail.com>

Added setting to email-clients that is easier to read
and is easier to setup thunderbird. Removed config settings
and added GUI settings.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/email-clients.txt |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- lnx-315-rc2.orig/Documentation/email-clients.txt
+++ lnx-315-rc2/Documentation/email-clients.txt
@@ -201,20 +201,15 @@ To beat some sense out of the internal e
 
 - Edit your Thunderbird config settings so that it won't use format=flowed.
   Go to "edit->preferences->advanced->config editor" to bring up the
-  thunderbird's registry editor, and set "mailnews.send_plaintext_flowed" to
-  "false".
+  thunderbird's registry editor.
 
-- Disable HTML Format: Set "mail.identity.id1.compose_html" to "false".
+- Set "mailnews.send_plaintext_flowed" to "false"
 
-- Enable "preformat" mode: Set "editor.quotesPreformatted" to "true".
+- Set "mailnews.wraplength" from "72" to "0"
 
-- Enable UTF8: Set "prefs.converted-to-utf8" to "true".
+- "View" > "Message Body As" > "Plain Text"
 
-- Install the "toggle wordwrap" extension.  Download the file from:
-    https://addons.mozilla.org/thunderbird/addon/2351/
-  Then go to "tools->add ons", select "install" at the bottom of the screen,
-  and browse to where you saved the .xul file.  This adds an "Enable
-  Wordwrap" entry under the Options menu of the message composer.
+- "View" > "Character Encoding" > "Unicode (UTF-8)"
 
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 TkRat (GUI)
