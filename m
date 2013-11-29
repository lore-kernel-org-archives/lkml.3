Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3K2Mzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:55:52 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59083 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab3K2Mzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:55:51 -0500
X-Originating-IP: 109.242.151.66
From: Aldo Iljazi <mail@aldo.io>
To: lidza.louina@gmail.com
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: dgnc: dgnc_trace.c: fixed coding style issues
Date: Fri, 29 Nov 2013 14:55:37 +0200
Message-Id: <1385729737-6052-1-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following coding style issues:

Lines 66-70: Replaced spaced with tabs.
Lines 75, 98, 182: Inserted space before the open parenthesis.
Line 89: Inserted spaces around that '='

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 drivers/staging/dgnc/dgnc_trace.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_trace.c b/drivers/staging/dgnc/dgnc_trace.c
index a98b7d4..e59b781 100644
--- a/drivers/staging/dgnc/dgnc_trace.c
+++ b/drivers/staging/dgnc/dgnc_trace.c
@@ -63,16 +63,16 @@ void dgnc_tracef(const char *fmt, ...)
 
 void dgnc_tracef(const char *fmt, ...)
 {
-	va_list	         ap;
-	char  	         buf[TRC_MAXMSG+1];
-	size_t		 lenbuf;
-	int		 i;
-	static int	 failed = FALSE;
+	va_list		ap;
+	char		buf[TRC_MAXMSG+1];
+	size_t		lenbuf;
+	int		i;
+	static int	failed = FALSE;
 # if defined(TRC_TO_KMEM)
 	unsigned long	 flags;
 #endif
 
-	if(failed)
+	if (failed)
 		return;
 # if defined(TRC_TO_KMEM)
 	DGNC_LOCK(dgnc_tracef_lock, flags);
@@ -86,7 +86,7 @@ void dgnc_tracef(const char *fmt, ...)
 
 # if defined(TRC_TO_KMEM)
 	{
-		static int	 initd=0;
+		static int	 initd = 0;
 
 		/*
 		 * Now, in addition to (or instead of) printing this stuff out
@@ -95,7 +95,7 @@ void dgnc_tracef(const char *fmt, ...)
 		 */
 		if (!initd) {
 			dgnc_trcbuf = (char *) vmalloc(dgnc_trcbuf_size);
-			if(!dgnc_trcbuf) {
+			if (!dgnc_trcbuf) {
 				failed = TRUE;
 				printk("dgnc: tracing init failed!\n");
 				return;
@@ -179,6 +179,6 @@ void dgnc_tracef(const char *fmt, ...)
  */
 void dgnc_tracer_free(void)
 {
-	if(dgnc_trcbuf)
+	if (dgnc_trcbuf)
 		vfree(dgnc_trcbuf);
 }
-- 
1.7.9.5

