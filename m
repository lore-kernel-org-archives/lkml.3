Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaADP2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:28:52 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49286 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713AbaADPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:25:43 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] Staging: vt6656: Remove unnecessary semicolons
Date: Sat,  4 Jan 2014 16:25:08 +0100
Message-Id: <1388849118-11994-4-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

After some blocks in bssdb.c there are semicolons that are not
required to be there. Therefore they are removed with this patch.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index d727662..e9c61ee 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -287,7 +287,7 @@ PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
 	}
 
 	return NULL;
-};
+}
 
 /*
  * Routine Description:
@@ -677,7 +677,7 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 	pMgmt->sNodeDBTable[*puNodeIndex].byAuthSequence = 0;
 	pMgmt->sNodeDBTable[*puNodeIndex].wEnQueueCnt = 0;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Create node index = %d\n", ii);
-};
+}
 
 /*
  * Routine Description:
@@ -699,7 +699,7 @@ void BSSvRemoveOneNode(struct vnt_private *pDevice, u32 uNodeIndex)
 	memset(&pMgmt->sNodeDBTable[uNodeIndex], 0, sizeof(KnownNodeDB));
 	/* clear tx bit map */
 	pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[uNodeIndex].wAID >> 3] &=  ~byMask[pMgmt->sNodeDBTable[uNodeIndex].wAID & 7];
-};
+}
 
 /*
  * Routine Description:
@@ -746,7 +746,7 @@ void BSSvUpdateAPNode(struct vnt_private *pDevice,
 	 * RATEbInit(pDevice); */
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pMgmt->sNodeDBTable[0].wTxDataRate = %d \n", pMgmt->sNodeDBTable[0].wTxDataRate);
 
-};
+}
 
 /*
  * Routine Description:
@@ -778,7 +778,7 @@ void BSSvAddMulticastNode(struct vnt_private *pDevice)
 	pMgmt->sNodeDBTable[0].wTxDataRate = pMgmt->sNodeDBTable[0].wMaxBasicRate;
 	pMgmt->sNodeDBTable[0].uRatePollTimeout = FALLBACK_POLL_SECOND;
 
-};
+}
 
 /*
  * Routine Description:
@@ -1081,7 +1081,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 				bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
 				pDevice->uAutoReConnectTime = 0;
-			};
+			}
 		}
 		if (pMgmt->eCurrState == WMAC_STATE_JOINTED) {
 
@@ -1307,7 +1307,7 @@ void BSSvClearNodeDBTable(struct vnt_private *pDevice, u32 uStartIndex)
 			memset(&pMgmt->sNodeDBTable[ii], 0, sizeof(KnownNodeDB));
 		}
 	}
-};
+}
 
 static void s_vCheckSensitivity(struct vnt_private *pDevice)
 {
-- 
1.8.1.2

