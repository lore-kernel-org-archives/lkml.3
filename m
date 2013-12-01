Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3LAPn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 10:43:29 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41635 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3LAPn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 10:43:26 -0500
X-Originating-IP: 109.242.63.236
From: Aldo Iljazi <mail@aldo.io>
To: lidza.louina@gmail.com
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Drivers: staging: dgap: checkpatch.pl cleanups
Date: Sun,  1 Dec 2013 17:43:08 +0200
Message-Id: <1385912589-32709-1-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few checkpatch cleanups, particularly:

Lines 83, 87, 89, 196: Removed spaces before tabs.
Lines 141, 265.267: Removed trailing whitespace.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 drivers/staging/dgap/dgap_conf.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/dgap/dgap_conf.h b/drivers/staging/dgap/dgap_conf.h
index 8809701..32ac17c 100644
--- a/drivers/staging/dgap/dgap_conf.h
+++ b/drivers/staging/dgap/dgap_conf.h
@@ -80,13 +80,13 @@
 #define MC8E8K  36
 
 #define AVANFS	42	/* start of Avanstar family definitions */
-#define A8P 	42
+#define A8P	42
 #define A16P	43
 #define AVANFE	43	/* end of Avanstar family definitions */
 
 #define DA2000FS	44	/* start of AccelePort 2000 family definitions */
-#define DA22 		44 /* AccelePort 2002 */
-#define DA24 		45 /* AccelePort 2004 */
+#define DA22		44 /* AccelePort 2002 */
+#define DA24		45 /* AccelePort 2004 */
 #define DA28		46 /* AccelePort 2008 */
 #define DA216		47 /* AccelePort 2016 */
 #define DAR4		48 /* AccelePort RAS 4 port */
@@ -138,11 +138,11 @@
 #define	CU	91
 #define	PRINT	92
 #define	XPRINT	93
-#define CMAJOR   94 
-#define ALTPIN  95
-#define STARTO 96
-#define USEINTR  97
-#define PCIINFO  98
+#define CMAJOR	94
+#define ALTPIN	95
+#define STARTO	96
+#define USEINTR	97
+#define PCIINFO	98
 
 #define	TTSIZ	100
 #define	CHSIZ	101
@@ -193,7 +193,7 @@ struct cnode {
 
 	union {
 		struct {
-			char  type;	/* Board Type 		*/
+			char  type;	/* Board Type		*/
 			short port;	/* I/O Address		*/
 			char  *portstr; /* I/O Address in string */
 			long  addr;	/* Memory Address	*/
@@ -262,9 +262,9 @@ struct cnode {
 		} module;
 
 		char *ttyname;
-		
+
 		char *cuname;
-		
+
 		char *printname;
 
 		int  majornumber;
-- 
1.7.9.5

