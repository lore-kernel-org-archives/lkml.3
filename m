Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbbANNIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:08:40 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41684 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbbANNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:08:39 -0500
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] dgnc: checkpatch: macros in enclosed parantheses
Date: Wed, 14 Jan 2015 14:08:33 +0100
Message-Id: <1421240913-32192-1-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <0141223162911.GB4273@kroah.com>
References: <0141223162911.GB4273@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dpacompat.h and digi.h partly define the same macros, so it is necessary to
change them both.

Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
---
 drivers/staging/dgnc/digi.h      | 58 ++++++++++++++++++++--------------------
 drivers/staging/dgnc/dpacompat.h | 12 ++++-----
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/dgnc/digi.h b/drivers/staging/dgnc/digi.h
index 3181a35..7d94704 100644
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
 						/* control characters	 */
-#define	DIGI_SETFLOW	('e'<<8) | 100		/* Set startc/stopc flow */
+#define	DIGI_SETFLOW	(('e'<<8) | 100)	/* Set startc/stopc flow */
 						/* control characters	 */
-#define	DIGI_GETAFLOW	('e'<<8) | 101		/* Get Aux. startc/stopc */
+#define	DIGI_GETAFLOW	(('e'<<8) | 101)	/* Get Aux. startc/stopc */
 						/* flow control chars	 */
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
+#define	DIGI_GETCH	(('d'<<8) | 245)	/* get board info          */
 
 /* Board type definitions */
 
@@ -389,10 +389,10 @@ struct digi_getcounter {
 #define DIGI_SETCUSTOMBAUD	_IOW('e', 106, int)	/* Set integer baud rate */
 #define DIGI_GETCUSTOMBAUD	_IOR('e', 107, int)	/* Get integer baud rate */
 
-#define DIGI_REALPORT_GETBUFFERS ('e'<<8) | 108
-#define DIGI_REALPORT_SENDIMMEDIATE ('e'<<8) | 109
-#define DIGI_REALPORT_GETCOUNTERS ('e'<<8) | 110
-#define DIGI_REALPORT_GETEVENTS ('e'<<8) | 111
+#define DIGI_REALPORT_GETBUFFERS (('e'<<8) | 108)
+#define DIGI_REALPORT_SENDIMMEDIATE (('e'<<8) | 109)
+#define DIGI_REALPORT_GETCOUNTERS (('e'<<8) | 110)
+#define DIGI_REALPORT_GETEVENTS (('e'<<8) | 111)
 
 #define EV_OPU		0x0001		/* !<Output paused by client */
 #define EV_OPS		0x0002		/* !<Output paused by reqular sw flowctrl */
diff --git a/drivers/staging/dgnc/dpacompat.h b/drivers/staging/dgnc/dpacompat.h
index b2d2dc0..bc9195f 100644
--- a/drivers/staging/dgnc/dpacompat.h
+++ b/drivers/staging/dgnc/dpacompat.h
@@ -51,7 +51,7 @@ struct ni_info {
 
 #define RW_READ		1
 #define RW_WRITE        2
-#define DIGI_KME        ('e'<<8) | 98           /* Read/Write Host */
+#define DIGI_KME        (('e'<<8) | 98)		/* Read/Write Host */
 
 #define SUBTYPE         0007
 #define T_PCXI          0000
@@ -106,10 +106,10 @@ struct ni_info {
 
 /* Ioctls needed for dpa operation */
 
-#define DIGI_GETDD      ('d'<<8) | 248          /* get driver info      */
-#define DIGI_GETBD      ('d'<<8) | 249          /* get board info       */
-#define DIGI_GET_NI_INFO ('d'<<8) | 250		/* nonintelligent state snfo */
+#define DIGI_GETDD      (('d'<<8) | 248)	/* get driver info      */
+#define DIGI_GETBD      (('d'<<8) | 249)	/* get board info       */
+#define DIGI_GET_NI_INFO (('d'<<8) | 250)	/* nonintelligent state snfo */
 
 /* Other special ioctls */
-#define DIGI_TIMERIRQ ('d'<<8) | 251		/* Enable/disable RS_TIMER use */
-#define DIGI_LOOPBACK ('d'<<8) | 252		/* Enable/disable UART internal loopback */
+#define DIGI_TIMERIRQ (('d'<<8) | 251)		/* Enable/disable RS_TIMER use */
+#define DIGI_LOOPBACK (('d'<<8) | 252)		/* Enable/disable UART internal loopback */
-- 
1.9.1

