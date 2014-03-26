Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaCZS7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:59:07 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:34713 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbaCZS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:59:05 -0400
Message-ID: <53332374.3000703@gmail.com>
Date: Wed, 26 Mar 2014 18:59:00 +0000
From: paulmcquad <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paul McQuade <paulmcquad@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Doc: email-clients.txt:added thunderbird settings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9c385609591c5ed87989a127c95da95aa8845162 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Tue, 25 Mar 2014 20:16:47 +0000
Subject: [PATCH] Doc: email-clients.txt:added thunderbird settings

Added setting to email-clients that is easier to read
and is easier to setup thunderbird. Removed config settings
and added GUI settings.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 Documentation/email-clients.txt | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index e9f5dac..1e7c171 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -201,20 +201,15 @@ To beat some sense out of the internal editor, do this:
 
 - Edit your Thunderbird config settings so that it won't use format=flowed.
   Go to "edit->preferences->advanced->config editor" to bring up the
-  thunderbird's registry editor, and set "mailnews.send_plaintext_flowed" to
-  "false".
+  thunderbird's registry editor.
 
-- Disable HTML Format: Set "mail.identity.id1.compose_html" to "false".
+- Set "mailnews.send_plaintext_flowed" to "false"
 
-- Enable "preformat" mode: Set "editor.quotesPreformatted" to "true".
+- Set "mailnews.wraplength" from "72" to "90"
 
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
-- 
1.8.3.2

