Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaFPLCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:02:01 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62302 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaFPLB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:01:58 -0400
From: Robin Schroer <sulamiification@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Robin Schroer <sulamiification@gmail.com>
Subject: [PATCH 2/3] drivers/staging/bcm/Misc: style: removed duplicate parentheses
Date: Mon, 16 Jun 2014 13:01:47 +0200
Message-Id: <1402916508-9846-2-git-send-email-sulamiification@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402916508-9846-1-git-send-email-sulamiification@gmail.com>
References: <1402916508-9846-1-git-send-email-sulamiification@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/staging/bcm/Misc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index f2bc699..a0637eb 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -284,7 +284,7 @@ int CopyBufferToControlPacket(struct bcm_mini_adapter *Adapter, void *ioBuffer)
 			pLeader->Status == CM_CONTROL_NEWDSX_MULTICLASSIFIER_REQ) {
 
 			if ((pLeader->Status == LINK_UP_CONTROL_REQ) && (pLinkReq->szData[0] == LINK_DOWN_REQ_PAYLOAD))	{
-				if ((pLinkReq->szData[1] == LINK_SYNC_DOWN_SUBTYPE)) {
+				if (pLinkReq->szData[1] == LINK_SYNC_DOWN_SUBTYPE) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_CONTROL, DBG_LVL_ALL, "Link Down Sent in Idle Mode\n");
 					Adapter->usIdleModePattern = ABORT_IDLE_SYNCDOWN; /* LINK DOWN sent in Idle Mode */
 				} else {
@@ -630,7 +630,7 @@ void SendIdleModeResponse(struct bcm_mini_adapter *Adapter)
 	}
 
 	status = CopyBufferToControlPacket(Adapter, &stIdleResponse);
-	if ((status != STATUS_SUCCESS)) {
+	if (status != STATUS_SUCCESS) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "fail to send the Idle mode Request\n");
 		Adapter->bPreparingForLowPowerMode = false;
 		StartInterruptUrb((struct bcm_interface_adapter *)(Adapter->pvInterfaceAdapter));
@@ -1393,7 +1393,7 @@ static void SendShutModeResponse(struct bcm_mini_adapter *Adapter)
 	}
 
 	Status = CopyBufferToControlPacket(Adapter, &stShutdownResponse);
-	if ((Status != STATUS_SUCCESS)) {
+	if (Status != STATUS_SUCCESS) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, MP_SHUTDOWN, DBG_LVL_ALL, "fail to send the Idle mode Request\n");
 		Adapter->bPreparingForLowPowerMode = false;
 		StartInterruptUrb((struct bcm_interface_adapter *)(Adapter->pvInterfaceAdapter));
-- 
2.0.0

