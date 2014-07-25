Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaGYPsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:48:11 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62391 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaGYPsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:48:09 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from datarate.h
Date: Fri, 25 Jul 2014 18:47:53 +0300
Message-Id: <1406303273-31263-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from datarate.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/datarate.h |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/datarate.h b/drivers/staging/vt6655/datarate.h
index e4fad05..0509c4f 100644
--- a/drivers/staging/vt6655/datarate.h
+++ b/drivers/staging/vt6655/datarate.h
@@ -29,25 +29,15 @@
 #ifndef __DATARATE_H__
 #define __DATARATE_H__
 
-/*---------------------  Export Definitions -------------------------*/
-
-#define FALLBACK_PKT_COLLECT_TR_H  50   // pkts
-#define FALLBACK_PKT_COLLECT_TR_L  10   // pkts
-#define FALLBACK_POLL_SECOND       5    // 5 sec
-#define FALLBACK_RECOVER_SECOND    30   // 30 sec
-#define FALLBACK_THRESHOLD         15   // percent
-#define UPGRADE_THRESHOLD          5    // percent
-#define UPGRADE_CNT_THRD           3    // times
-#define RETRY_TIMES_THRD_H         2    // times
-#define RETRY_TIMES_THRD_L         1    // times
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
+#define FALLBACK_PKT_COLLECT_TR_H  50
+#define FALLBACK_PKT_COLLECT_TR_L  10
+#define FALLBACK_POLL_SECOND       5
+#define FALLBACK_RECOVER_SECOND    30
+#define FALLBACK_THRESHOLD         15
+#define UPGRADE_THRESHOLD          5
+#define UPGRADE_CNT_THRD           3
+#define RETRY_TIMES_THRD_H         2
+#define RETRY_TIMES_THRD_L         1
 
 void
 RATEvParseMaxRate(
-- 
1.7.9.5

