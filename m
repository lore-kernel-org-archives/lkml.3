Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbaGVPWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:22:17 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48273 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaGVPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:22:16 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>,
        Lidza Louina <lidza.louina@gmail.com>
Subject: [PATCH] staging: dgnc: Remove all C99 comments
Date: Wed, 23 Jul 2014 00:21:57 +0900
Message-Id: <1406042517-13198-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch error:

ERROR: do not use C99 // comments

CC: Lidza Louina <lidza.louina@gmail.com>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.h |   10 +++++-----
 drivers/staging/dgnc/digi.h        |   36 ++++++++++++++++++------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h
index 3519b80..fe5ea90 100644
--- a/drivers/staging/dgnc/dgnc_driver.h
+++ b/drivers/staging/dgnc/dgnc_driver.h
@@ -98,7 +98,7 @@
 /* Choose one: */
 #  define TRC_ON_OVERFLOW_WRAP_AROUND
 #  undef  TRC_ON_OVERFLOW_SHIFT_BUFFER
-# endif //TRC_TO_KMEM
+# endif /* TRC_TO_KMEM */
 
 # define TRC_MAXMSG		1024
 # define TRC_OVERFLOW		"(OVERFLOW)"
@@ -106,13 +106,13 @@
 
 #if defined TRC_TO_CONSOLE
 #define PRINTF_TO_CONSOLE(args) { printk(DRVSTR": "); printk args; }
-#else //!defined TRACE_TO_CONSOLE
+#else /* !defined TRACE_TO_CONSOLE */
 #define PRINTF_TO_CONSOLE(args)
 #endif
 
 #if defined TRC_TO_KMEM
 #define PRINTF_TO_KMEM(args) dgnc_tracef args
-#else //!defined TRC_TO_KMEM
+#else /* !defined TRC_TO_KMEM */
 #define PRINTF_TO_KMEM(args)
 #endif
 
@@ -140,7 +140,7 @@
 # define P(X)			dgnc_tracef(#X "=%p\n", X)
 # define X(X)			dgnc_tracef(#X "=%x\n", X)
 
-#else//!defined DGNC_TRACER
+#else/* !defined DGNC_TRACER */
 
 #define PRINTF_TO_KMEM(args)
 # define TRC(ARGS)
@@ -164,7 +164,7 @@
 
 # define DPR(args)
 
-#endif//DGNC_TRACER
+#endif/* DGNC_TRACER */
 
 /* Number of boards we support at once. */
 #define	MAXBOARDS	20
diff --git a/drivers/staging/dgnc/digi.h b/drivers/staging/dgnc/digi.h
index 6a9adf6..282908f 100644
--- a/drivers/staging/dgnc/digi.h
+++ b/drivers/staging/dgnc/digi.h
@@ -394,23 +394,23 @@ struct digi_getcounter {
 #define DIGI_REALPORT_GETCOUNTERS ('e'<<8 ) | 110
 #define DIGI_REALPORT_GETEVENTS ('e'<<8 ) | 111
 
-#define EV_OPU		0x0001		//!<Output paused by client
-#define EV_OPS		0x0002		//!<Output paused by reqular sw flowctrl
-#define EV_OPX		0x0004		//!<Output paused by extra sw flowctrl
-#define EV_OPH		0x0008		//!<Output paused by hw flowctrl
-#define EV_OPT		0x0800		//!<Output paused for RTS Toggle predelay
-
-#define EV_IPU		0x0010		//!<Input paused unconditionally by user
-#define EV_IPS		0x0020		//!<Input paused by high/low water marks
-//#define EV_IPH	0x0040		//!<Input paused w/ hardware
-#define EV_IPA		0x0400		//!<Input paused by pattern alarm module
-
-#define EV_TXB		0x0040		//!<Transmit break pending
-#define EV_TXI		0x0080		//!<Transmit immediate pending
-#define EV_TXF		0x0100		//!<Transmit flowctrl char pending
-#define EV_RXB		0x0200		//!<Break received
-
-#define EV_OPALL	0x080f		//!<Output pause flags
-#define EV_IPALL	0x0430		//!<Input pause flags
+#define EV_OPU		0x0001		/* !<Output paused by client */
+#define EV_OPS		0x0002		/* !<Output paused by reqular sw flowctrl */
+#define EV_OPX		0x0004		/* !<Output paused by extra sw flowctrl */
+#define EV_OPH		0x0008		/* !<Output paused by hw flowctrl */
+#define EV_OPT		0x0800		/* !<Output paused for RTS Toggle predelay */
+
+#define EV_IPU		0x0010		/* !<Input paused unconditionally by user */
+#define EV_IPS		0x0020		/* !<Input paused by high/low water marks */
+/* #define EV_IPH	0x0040		//!<Input paused w/ hardware */
+#define EV_IPA		0x0400		/* !<Input paused by pattern alarm module */
+
+#define EV_TXB		0x0040		/* !<Transmit break pending */
+#define EV_TXI		0x0080		/* !<Transmit immediate pending */
+#define EV_TXF		0x0100		/* !<Transmit flowctrl char pending */
+#define EV_RXB		0x0200		/* !<Break received */
+
+#define EV_OPALL	0x080f		/* !<Output pause flags */
+#define EV_IPALL	0x0430		/* !<Input pause flags */
 
 #endif /* DIGI_H */
-- 
1.7.9.5

