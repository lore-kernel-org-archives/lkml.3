Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3H3Te5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:34:57 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50961 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3H3Te4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:34:56 -0400
Message-ID: <5220F3DC.6030604@gmail.com>
Date: Fri, 30 Aug 2013 20:34:52 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Email-clients:More config Settings for Thunderbird
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1e86f069b7cacdd6d369eac40b4b7aba7a0523a6 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Fri, 30 Aug 2013 20:24:38 +0100
Subject: [PATCH] Email-clients:More config Settings for Thunderbird

Disable Word Wrap
Default Charset

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 Documentation/email-clients.txt |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index 860c29a..b0e71c0 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -205,13 +205,17 @@ To beat some sense out of the internal editor, do this:
   "false".
 
 - Disable HTML Format: Set "mail.identity.id1.compose_html" to "false".
-
-- Enable "preformat" mode: Set "editor.quotesPreformatted" to "true".
+  OR Account Settings: Composition & Addressing: Untick "Compose messages in HTML format".
 
 - Enable UTF8: Set "prefs.converted-to-utf8" to "true".
 
-- Install the "toggle wordwrap" extension.  Download the file from:
-    https://addons.mozilla.org/thunderbird/addon/2351/
+- Default Charset: Set "mailnews.Send_default_charset" to "UTF-8"
+
+- Disable Word Wrap: Set "mailnews.wraplength" to "0".
+
+- You can also use the addon "toggle wordwrap" extension.
+  From:
+  https://addons.mozilla.org/thunderbird/addon/2351/
   Then go to "tools->add ons", select "install" at the bottom of the screen,
   and browse to where you saved the .xul file.  This adds an "Enable
   Wordwrap" entry under the Options menu of the message composer.
-- 
1.7.10.4
