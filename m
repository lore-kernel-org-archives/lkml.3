Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbaGOTZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:25:12 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:37082 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaGOTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:25:07 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] alpha: Fix spacing in misc.c
Date: Tue, 15 Jul 2014 15:18:07 -0400
Message-Id: <1405451890-6057-2-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405451890-6057-1-git-send-email-xerofoify@gmail.com>
References: <1405451890-6057-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to errors with checkpatch in this file I am checking certain defintions
spacing to pass checkpatch for spacing issues.
---
 arch/alpha/boot/misc.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/boot/misc.c b/arch/alpha/boot/misc.c
index 3f86c3e..119d500 100644
--- a/arch/alpha/boot/misc.c
+++ b/arch/alpha/boot/misc.c
@@ -23,10 +23,10 @@
 
 #include <asm/uaccess.h>
 
-#define memzero(s,n)	memset ((s),0,(n))
+#define memzero (s, n)	memset((s), 0 , (n))
 #define puts		srm_printk
 extern long srm_printk(const char *, ...)
-     __attribute__ ((format (printf, 1, 2)));
+	__attribute__ ((format (printf, 1, 2)));
 
 /*
  * gzip delarations
@@ -61,19 +61,19 @@ static unsigned outcnt;		/* bytes in output buffer */
 
 /* Diagnostic functions */
 #ifdef DEBUG
-#  define Assert(cond,msg) {if(!(cond)) error(msg);}
+#  define Assert (cond, msg) {if (!(cond)) error(msg) ; }
 #  define Trace(x) fprintf x
-#  define Tracev(x) {if (verbose) fprintf x ;}
-#  define Tracevv(x) {if (verbose>1) fprintf x ;}
-#  define Tracec(c,x) {if (verbose && (c)) fprintf x ;}
-#  define Tracecv(c,x) {if (verbose>1 && (c)) fprintf x ;}
+#  define Tracev(x) {if (verbose) fprintf x ; }
+#  define Tracevv(x) {if (verbose > 1) fprintf x ; }
+#  define Tracec(c, x) {if (verbose && (c)) fprintf x ; }
+#  define Tracecv(c, x) {if (verbose > 1 && (c)) fprintf x ; }
 #else
-#  define Assert(cond,msg)
+#  define Assert(cond, msg)
 #  define Trace(x)
 #  define Tracev(x)
 #  define Tracevv(x)
-#  define Tracec(c,x)
-#  define Tracecv(c,x)
+#  define Tracec(c, x)
+#  define Tracecv(c, x)
 #endif
 
 static int  fill_inbuf(void);
@@ -144,7 +144,8 @@ static void error(char *x)
 	puts(x);
 	puts("\n\n -- System halted");
 
-	while(1);	/* Halt */
+	while (1);	
+	/* Halt */
 }
 
 unsigned int
-- 
1.9.1

