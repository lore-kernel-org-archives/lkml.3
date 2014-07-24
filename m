Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbaGXP1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:27:04 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48874 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287AbaGXP1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:27:00 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH 1/3] staging: dgng: Fix Macros with complex values should be enclosed in parenthesis
Date: Fri, 25 Jul 2014 00:26:51 +0900
Message-Id: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a checkpatch errors
"Macros with complex values should be enclosed in parenthesis"

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.h |   40 ++++++++++++------------
 drivers/staging/dgnc/digi.h        |   60 ++++++++++++++++++------------------
 drivers/staging/dgnc/dpacompat.h   |   12 ++++----
 3 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h
index fe5ea90..f7730a1 100644
--- a/drivers/staging/dgnc/dgnc_driver.h
+++ b/drivers/staging/dgnc/dgnc_driver.h
@@ -111,32 +111,32 @@
 #endif
 
 #if defined TRC_TO_KMEM
-#define PRINTF_TO_KMEM(args) dgnc_tracef args
+#define PRINTF_TO_KMEM(args) do { dgnc_tracef args } while (0)
 #else /* !defined TRC_TO_KMEM */
 #define PRINTF_TO_KMEM(args)
 #endif
 
 #define	TRC(args)	{ PRINTF_TO_KMEM(args); PRINTF_TO_CONSOLE(args) }
 
-# define DPR_INIT(ARGS)		if (DBG_INIT) TRC(ARGS)
-# define DPR_BASIC(ARGS)	if (DBG_BASIC) TRC(ARGS)
-# define DPR_CORE(ARGS)		if (DBG_CORE) TRC(ARGS)
-# define DPR_OPEN(ARGS)		if (DBG_OPEN)  TRC(ARGS)
-# define DPR_CLOSE(ARGS)	if (DBG_CLOSE)  TRC(ARGS)
-# define DPR_READ(ARGS)		if (DBG_READ)  TRC(ARGS)
-# define DPR_WRITE(ARGS)	if (DBG_WRITE) TRC(ARGS)
-# define DPR_IOCTL(ARGS)	if (DBG_IOCTL) TRC(ARGS)
-# define DPR_PROC(ARGS)		if (DBG_PROC)  TRC(ARGS)
-# define DPR_PARAM(ARGS)	if (DBG_PARAM)  TRC(ARGS)
-# define DPR_PSCAN(ARGS)	if (DBG_PSCAN)  TRC(ARGS)
-# define DPR_EVENT(ARGS)	if (DBG_EVENT)  TRC(ARGS)
-# define DPR_DRAIN(ARGS)	if (DBG_DRAIN)  TRC(ARGS)
-# define DPR_CARR(ARGS)		if (DBG_CARR)  TRC(ARGS)
-# define DPR_MGMT(ARGS)		if (DBG_MGMT)  TRC(ARGS)
-# define DPR_INTR(ARGS)		if (DBG_INTR)  TRC(ARGS)
-# define DPR_MSIGS(ARGS)	if (DBG_MSIGS)  TRC(ARGS)
-
-# define DPR(ARGS)		if (dgnc_debug) TRC(ARGS)
+# define DPR_INIT(ARGS)		do { if (DBG_INIT) TRC(ARGS) } while (0)
+# define DPR_BASIC(ARGS)	do { if (DBG_BASIC) TRC(ARGS) } while (0)
+# define DPR_CORE(ARGS)		do { if (DBG_CORE) TRC(ARGS) } while (0)
+# define DPR_OPEN(ARGS)		do { if (DBG_OPEN)  TRC(ARGS) } while (0)
+# define DPR_CLOSE(ARGS)	do { if (DBG_CLOSE)  TRC(ARGS) } while (0)
+# define DPR_READ(ARGS)		do { if (DBG_READ)  TRC(ARGS) } while (0)
+# define DPR_WRITE(ARGS)	do { if (DBG_WRITE) TRC(ARGS) } while (0)
+# define DPR_IOCTL(ARGS)	do { if (DBG_IOCTL) TRC(ARGS) } while (0)
+# define DPR_PROC(ARGS)		do { if (DBG_PROC)  TRC(ARGS) } while (0)
+# define DPR_PARAM(ARGS)	do { if (DBG_PARAM)  TRC(ARGS) } while (0)
+# define DPR_PSCAN(ARGS)	do { if (DBG_PSCAN)  TRC(ARGS) } while (0)
+# define DPR_EVENT(ARGS)	do { if (DBG_EVENT)  TRC(ARGS) } while (0)
+# define DPR_DRAIN(ARGS)	do { if (DBG_DRAIN)  TRC(ARGS) } while (0)
+# define DPR_CARR(ARGS)		do { if (DBG_CARR)  TRC(ARGS) } while (0)
+# define DPR_MGMT(ARGS)		do { if (DBG_MGMT)  TRC(ARGS) } while (0)
+# define DPR_INTR(ARGS)		do { if (DBG_INTR)  TRC(ARGS) } while (0)
+# define DPR_MSIGS(ARGS)	do { if (DBG_MSIGS)  TRC(ARGS) } while (0)
+
+# define DPR(ARGS)		do { if (dgnc_debug) TRC(ARGS) } while (0)
 # define P(X)			dgnc_tracef(#X "=%p\n", X)
 # define X(X)			dgnc_tracef(#X "=%x\n", X)
 
diff --git a/drivers/staging/dgnc/digi.h b/drivers/staging/dgnc/digi.h
index 282908f..086cd9a 100644
--- a/drivers/staging/dgnc/digi.h
+++ b/drivers/staging/dgnc/digi.h
@@ -38,8 +38,8 @@
 
 #if !defined(TIOCMODG)
 
-#define	TIOCMODG	('d'<<8) | 250		/* get modem ctrl state	*/
-#define	TIOCMODS	('d'<<8) | 251		/* set modem ctrl state	*/
+#define	TIOCMODG	(('d'<<8) | 250)	/* get modem ctrl state	*/
+#define	TIOCMODS	(('d'<<8) | 251)	/* set modem ctrl state	*/
 
 #ifndef TIOCM_LE
 #define		TIOCM_LE	0x01		/* line enable		*/
@@ -58,44 +58,44 @@
 #endif
 
 #if !defined(TIOCMSET)
-#define	TIOCMSET	('d'<<8) | 252		/* set modem ctrl state	*/
-#define	TIOCMGET	('d'<<8) | 253		/* set modem ctrl state	*/
+#define	TIOCMSET	(('d'<<8) | 252)	/* set modem ctrl state	*/
+#define	TIOCMGET	(('d'<<8) | 253)	/* set modem ctrl state	*/
 #endif
 
 #if !defined(TIOCMBIC)
-#define	TIOCMBIC	('d'<<8) | 254		/* set modem ctrl state */
-#define	TIOCMBIS	('d'<<8) | 255		/* set modem ctrl state */
+#define	TIOCMBIC	(('d'<<8) | 254)	/* set modem ctrl state */
+#define	TIOCMBIS	(('d'<<8) | 255)	/* set modem ctrl state */
 #endif
 
 
 #if !defined(TIOCSDTR)
-#define	TIOCSDTR	('e'<<8) | 0		/* set DTR		*/
-#define	TIOCCDTR	('e'<<8) | 1		/* clear DTR		*/
+#define	TIOCSDTR	(('e'<<8) | 0)		/* set DTR		*/
+#define	TIOCCDTR	(('e'<<8) | 1)		/* clear DTR		*/
 #endif
 
 /************************************************************************
  * Ioctl command arguments for DIGI parameters.
  ************************************************************************/
-#define DIGI_GETA	('e'<<8) | 94		/* Read params		*/
+#define DIGI_GETA	(('e'<<8) | 94)		/* Read params		*/
 
-#define DIGI_SETA	('e'<<8) | 95		/* Set params		*/
-#define DIGI_SETAW	('e'<<8) | 96		/* Drain & set params	*/
-#define DIGI_SETAF	('e'<<8) | 97		/* Drain, flush & set params */
+#define DIGI_SETA	(('e'<<8) | 95)		/* Set params		*/
+#define DIGI_SETAW	(('e'<<8) | 96)		/* Drain & set params	*/
+#define DIGI_SETAF	(('e'<<8) | 97)		/* Drain, flush & set params */
 
-#define DIGI_KME	('e'<<8) | 98		/* Read/Write Host	*/
+#define DIGI_KME	(('e'<<8) | 98)		/* Read/Write Host	*/
 						/* Adapter Memory	*/
 
-#define	DIGI_GETFLOW	('e'<<8) | 99		/* Get startc/stopc flow */
+#define	DIGI_GETFLOW	(('e'<<8) | 99)		/* Get startc/stopc flow */
 						/* control characters 	 */
-#define	DIGI_SETFLOW	('e'<<8) | 100		/* Set startc/stopc flow */
+#define	DIGI_SETFLOW	(('e'<<8) | 100)	/* Set startc/stopc flow */
 						/* control characters	 */
-#define	DIGI_GETAFLOW	('e'<<8) | 101		/* Get Aux. startc/stopc */
+#define	DIGI_GETAFLOW	(('e'<<8) | 101)	/* Get Aux. startc/stopc */
 						/* flow control chars 	 */
-#define	DIGI_SETAFLOW	('e'<<8) | 102		/* Set Aux. startc/stopc */
+#define	DIGI_SETAFLOW	(('e'<<8) | 102)	/* Set Aux. startc/stopc */
 						/* flow control chars	 */
 
-#define DIGI_GEDELAY	('d'<<8) | 246		/* Get edelay */
-#define DIGI_SEDELAY	('d'<<8) | 247		/* Set edelay */
+#define DIGI_GEDELAY	(('d'<<8) | 246)	/* Get edelay */
+#define DIGI_SEDELAY	(('d'<<8) | 247)	/* Set edelay */
 
 struct	digiflow_t {
 	unsigned char	startc;				/* flow cntl start char	*/
@@ -104,8 +104,8 @@ struct	digiflow_t {
 
 
 #ifdef	FLOW_2200
-#define	F2200_GETA	('e'<<8) | 104		/* Get 2x36 flow cntl flags */
-#define	F2200_SETAW	('e'<<8) | 105		/* Set 2x36 flow cntl flags */
+#define	F2200_GETA	(('e'<<8) | 104)	/* Get 2x36 flow cntl flags */
+#define	F2200_SETAW	(('e'<<8) | 105)	/* Set 2x36 flow cntl flags */
 #define		F2200_MASK	0x03		/* 2200 flow cntl bit mask  */
 #define		FCNTL_2200	0x01		/* 2x36 terminal flow cntl  */
 #define		PCNTL_2200	0x02		/* 2x36 printer flow cntl   */
@@ -241,7 +241,7 @@ struct digi_dinfo {
 	char		dinfo_version[16];	/* driver version       */
 };
 
-#define	DIGI_GETDD	('d'<<8) | 248		/* get driver info      */
+#define	DIGI_GETDD	(('d'<<8) | 248)	/* get driver info      */
 
 /************************************************************************
  * Structure used with ioctl commands for per-board information
@@ -261,7 +261,7 @@ struct digi_info {
 	char		info_reserved[7];	/* for future expansion    */
 };
 
-#define	DIGI_GETBD	('d'<<8) | 249		/* get board info          */
+#define	DIGI_GETBD	(('d'<<8) | 249)	/* get board info          */
 
 struct digi_stat {
 	unsigned int	info_chan;		/* Channel number (0 based)  */
@@ -276,7 +276,7 @@ struct digi_stat {
 	unsigned int	info_reserved[8];	/* for future expansion    */
 };
 
-#define	DIGI_GETSTAT	('d'<<8) | 244		/* get board info          */
+#define	DIGI_GETSTAT	(('d'<<8) | 244)	/* get board info          */
 /************************************************************************
  *
  * Structure used with ioctl commands for per-channel information
@@ -339,7 +339,7 @@ struct digi_getcounter {
 #define INFO_CH_WLOW	0x0020
 #define INFO_XXBUF_BUSY 0x0040
 
-#define	DIGI_GETCH	('d'<<8) | 245		/* get board info          */
+#define	DIGI_GETCH	(('d'<<8) | 245)		/* get board info          */
 
 /* Board type definitions */
 
@@ -384,15 +384,15 @@ struct digi_getcounter {
 #define BD_TRIBOOT	0x8
 #define	BD_BADKME	0x80
 
-#define DIGI_SPOLL            ('d'<<8) | 254  /* change poller rate   */
+#define DIGI_SPOLL            (('d'<<8) | 254)		/* change poller rate   */
 
 #define DIGI_SETCUSTOMBAUD	_IOW('e', 106, int)	/* Set integer baud rate */
 #define DIGI_GETCUSTOMBAUD	_IOR('e', 107, int)	/* Get integer baud rate */
 
-#define DIGI_REALPORT_GETBUFFERS ('e'<<8 ) | 108
-#define DIGI_REALPORT_SENDIMMEDIATE ('e'<<8 ) | 109
-#define DIGI_REALPORT_GETCOUNTERS ('e'<<8 ) | 110
-#define DIGI_REALPORT_GETEVENTS ('e'<<8 ) | 111
+#define DIGI_REALPORT_GETBUFFERS	(('e'<<8) | 108)
+#define DIGI_REALPORT_SENDIMMEDIATE	(('e'<<8) | 109)
+#define DIGI_REALPORT_GETCOUNTERS	(('e'<<8) | 110)
+#define DIGI_REALPORT_GETEVENTS		(('e'<<8) | 111)
 
 #define EV_OPU		0x0001		/* !<Output paused by client */
 #define EV_OPS		0x0002		/* !<Output paused by reqular sw flowctrl */
diff --git a/drivers/staging/dgnc/dpacompat.h b/drivers/staging/dgnc/dpacompat.h
index f96963b..dc132c8 100644
--- a/drivers/staging/dgnc/dpacompat.h
+++ b/drivers/staging/dgnc/dpacompat.h
@@ -51,7 +51,7 @@
 
 #define RW_READ		1
 #define RW_WRITE        2
-#define DIGI_KME        ('e'<<8) | 98           /* Read/Write Host */
+#define DIGI_KME	(('e'<<8) | 98)           /* Read/Write Host */
 
 #define SUBTYPE         0007
 #define T_PCXI          0000
@@ -106,10 +106,10 @@
 
 /* Ioctls needed for dpa operation */
 
-#define DIGI_GETDD      ('d'<<8) | 248          /* get driver info      */
-#define DIGI_GETBD      ('d'<<8) | 249          /* get board info       */
-#define DIGI_GET_NI_INFO ('d'<<8) | 250		/* nonintelligent state snfo */
+#define DIGI_GETDD		(('d'<<8) | 248)	/* get driver info      */
+#define DIGI_GETBD		(('d'<<8) | 249)	/* get board info       */
+#define DIGI_GET_NI_INFO	(('d'<<8) | 250)	/* nonintelligent state snfo */
 
 /* Other special ioctls */
-#define DIGI_TIMERIRQ ('d'<<8) | 251		/* Enable/disable RS_TIMER use */
-#define DIGI_LOOPBACK ('d'<<8) | 252		/* Enable/disable UART internal loopback */
+#define DIGI_TIMERIRQ		(('d'<<8) | 251)	/* Enable/disable RS_TIMER use */
+#define DIGI_LOOPBACK		(('d'<<8) | 252)	/* Enable/disable UART internal loopback */
-- 
1.7.9.5

