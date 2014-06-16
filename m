Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaFPLCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:02:22 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44660 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaFPLCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:02:00 -0400
From: Robin Schroer <sulamiification@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Robin Schroer <sulamiification@gmail.com>
Subject: [PATCH 3/3] drivers/staging/bcm/Misc: style: removed void returns
Date: Mon, 16 Jun 2014 13:01:48 +0200
Message-Id: <1402916508-9846-3-git-send-email-sulamiification@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402916508-9846-1-git-send-email-sulamiification@gmail.com>
References: <1402916508-9846-1-git-send-email-sulamiification@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/staging/bcm/Misc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index a0637eb..a1c833c 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -21,7 +21,6 @@ static void default_wimax_protocol_initialize(struct bcm_mini_adapter *Adapter)
 	Adapter->LinkStatus = SYNC_UP_REQUEST;
 	Adapter->TransferMode = IP_PACKET_ONLY_MODE;
 	Adapter->usBestEffortQueueIndex = -1;
-	return;
 }
 
 int InitAdapter(struct bcm_mini_adapter *psAdapter)
@@ -460,7 +459,6 @@ void StatisticsResponse(struct bcm_mini_adapter *Adapter, void *pvBuffer)
 	Adapter->StatisticsPointer = ntohl(*(__be32 *)pvBuffer);
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "Stats at %x", (unsigned int)Adapter->StatisticsPointer);
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "%s <====", __func__);
-	return;
 }
 
 /**********************************************************************
@@ -545,7 +543,6 @@ void LinkControlResponseMessage(struct bcm_mini_adapter *Adapter, PUCHAR pucBuff
 		memcpy(Adapter->dev->dev_addr, puMacAddr, MAC_ADDRESS_SIZE);
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "%s <=====", __func__);
-	return;
 }
 
 void SendIdleModeResponse(struct bcm_mini_adapter *Adapter)
@@ -776,8 +773,6 @@ void DumpPackInfo(struct bcm_mini_adapter *Adapter)
 
 	for (uiLoopIndex = 0; uiLoopIndex < MIBS_MAX_HIST_ENTRIES; uiLoopIndex++)
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "Adapter->aTxPktSizeHist[%x] = %x\n", uiLoopIndex, Adapter->aTxPktSizeHist[uiLoopIndex]);
-
-	return;
 }
 
 int reset_card_proc(struct bcm_mini_adapter *ps_adapter)
@@ -1426,7 +1421,6 @@ static void HandleShutDownModeRequest(struct bcm_mini_adapter *Adapter, PUCHAR p
 	}
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, MP_SHUTDOWN, DBG_LVL_ALL, "<====\n");
-	return;
 }
 
 void ResetCounters(struct bcm_mini_adapter *Adapter)
-- 
2.0.0

