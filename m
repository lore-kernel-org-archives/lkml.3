Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177AbaGYQtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:49:07 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:33087 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934489AbaGYQtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:49:01 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from mib.h
Date: Fri, 25 Jul 2014 19:48:48 +0300
Message-Id: <1406306928-411-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from mib.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/mib.h |   45 +++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index c0a5948..732bdda 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -33,13 +33,12 @@
 #include "tether.h"
 #include "desc.h"
 
-/*---------------------  Export Definitions -------------------------*/
 //
 // 802.11 counter
 //
 
 typedef struct tagSDot11Counters {
-	unsigned long Length;             // Length of structure
+	unsigned long Length;
 	unsigned long long   TransmittedFragmentCount;
 	unsigned long long   MulticastTransmittedFrameCount;
 	unsigned long long   FailedCount;
@@ -68,8 +67,7 @@ typedef struct tagSDot11Counters {
 //
 typedef struct tagSMib2Counter {
 	long    ifIndex;
-	char    ifDescr[256];               // max size 255 plus zero ending
-	// e.g. "interface 1"
+	char    ifDescr[256];
 	long    ifType;
 	long    ifMtu;
 	unsigned long ifSpeed;
@@ -93,12 +91,12 @@ typedef struct tagSMib2Counter {
 } SMib2Counter, *PSMib2Counter;
 
 // Value in the ifType entry
-#define WIRELESSLANIEEE80211b      6           //
+#define WIRELESSLANIEEE80211b      6
 
 // Value in the ifAdminStatus/ifOperStatus entry
-#define UP                  1           //
-#define DOWN                2           //
-#define TESTING             3           //
+#define UP                  1
+#define DOWN                2
+#define TESTING             3
 
 //
 // RMON counter
@@ -182,7 +180,7 @@ typedef struct tagSISRCounters {
 	unsigned long dwIsrMIBNearfull;
 	unsigned long dwIsrRxNoBuf;
 
-	unsigned long dwIsrUnknown;               // unknown interrupt count
+	unsigned long dwIsrUnknown;
 
 	unsigned long dwIsrRx1OK;
 	unsigned long dwIsrATIMTxOK;
@@ -191,23 +189,18 @@ typedef struct tagSISRCounters {
 	unsigned long dwIsrATIMEnd;
 	unsigned long dwIsrSYNCFlushOK;
 	unsigned long dwIsrSTIMER1Int;
-	/////////////////////////////////////
 } SISRCounters, *PSISRCounters;
 
 // Value in the etherStatsStatus entry
-#define VALID               1           //
-#define CREATE_REQUEST      2           //
-#define UNDER_CREATION      3           //
-#define INVALID             4           //
+#define VALID               1
+#define CREATE_REQUEST      2
+#define UNDER_CREATION      3
+#define INVALID             4
 
 //
 // statistic counter
 //
 typedef struct tagSStatCounter {
-	//
-	// ISR status count
-	//
-
 	// RSR status count
 	//
 	unsigned long dwRsrFrmAlgnErr;
@@ -306,24 +299,18 @@ typedef struct tagSStatCounter {
 
 #ifdef Calcu_LinkQual
 	//Tx count:
-	unsigned long TxNoRetryOkCount;         //success tx no retry !
-	unsigned long TxRetryOkCount;              //success tx but retry !
-	unsigned long TxFailCount;                      //fail tx ?
+	unsigned long TxNoRetryOkCount;
+	unsigned long TxRetryOkCount;
+	unsigned long TxFailCount;
 	//Rx count:
-	unsigned long RxOkCnt;                          //success rx !
-	unsigned long RxFcsErrCnt;                    //fail rx ?
+	unsigned long RxOkCnt;
+	unsigned long RxFcsErrCnt;
 	//statistic
 	unsigned long SignalStren;
 	unsigned long LinkQuality;
 #endif
 } SStatCounter, *PSStatCounter;
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 void STAvClearAllCounter(PSStatCounter pStatistic);
 
 void STAvUpdateIsrStatCounter(PSStatCounter pStatistic, unsigned long dwIsr);
-- 
1.7.9.5

