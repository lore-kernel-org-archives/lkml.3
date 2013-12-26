Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3LZS7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:59:13 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50071 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842Ab3LZS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:57:42 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] Staging: vt6656: Remove unnecessary spaces in format strings
Date: Thu, 26 Dec 2013 19:55:36 +0100
Message-Id: <1388084140-21562-8-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388084140-21562-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388084140-21562-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

A space in a format string is unnecessary if it is followed by a line
feed. These spaces are removed by this patch.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 815324a..bd64d59 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -742,7 +742,7 @@ void BSSvUpdateAPNode(struct vnt_private *pDevice,
 	pMgmt->sNodeDBTable[0].uRatePollTimeout = FALLBACK_POLL_SECOND;
 	/* Auto rate fallback function initiation.
 	 * RATEbInit(pDevice); */
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pMgmt->sNodeDBTable[0].wTxDataRate = %d \n", pMgmt->sNodeDBTable[0].wTxDataRate);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pMgmt->sNodeDBTable[0].wTxDataRate = %d\n", pMgmt->sNodeDBTable[0].wTxDataRate);
 
 }
 
@@ -902,11 +902,11 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 			/* check if pending PS queue */
 			if (pMgmt->sNodeDBTable[ii].wEnQueueCnt != 0) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending \n",
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending\n",
 						   ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
 				if ((ii > 0) && (pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15)) {
 					BSSvRemoveOneNode(pDevice, ii);
-					DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Pending many queues PS STA Index = %d remove \n", ii);
+					DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Pending many queues PS STA Index = %d remove\n", ii);
 					continue;
 				}
 			}
-- 
1.8.1.2

