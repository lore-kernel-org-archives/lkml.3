Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbbARFKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 00:10:09 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49881 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbbARFKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 00:10:06 -0500
From: Andrew Milkovich <amilkovich@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Andrew Milkovich <amilkovich@gmail.com>
Subject: [PATCH] Staging: dgnc: fixed some coding style errors
Date: Sat, 17 Jan 2015 21:09:08 -0800
Message-Id: <1421557748-26522-1-git-send-email-amilkovich@gmail.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
ERROR: Macros with complex values should be enclosed in parentheses
Outer parentheses were added to macro definitions.

Signed-off-by: Andrew Milkovich <amilkovich@gmail.com>
---
 drivers/staging/dgnc/digi.h | 60 ++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/dgnc/digi.h b/drivers/staging/dgnc/digi.h
index 3181a35..d6e0b9f 100644
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
 
@@ -384,15 +384,15 @@ struct digi_getcounter {
 #define BD_TRIBOOT	0x8
 #define	BD_BADKME	0x80
 
-#define DIGI_SPOLL            ('d'<<8) | 254  /* change poller rate   */
+#define DIGI_SPOLL            (('d'<<8) | 254)  /* change poller rate   */
 
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
-- 
2.2.2

