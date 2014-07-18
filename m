Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbaGRBpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:45:32 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42108 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341AbaGRBpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:45:11 -0400
From: Khoa Mai <mdk194@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Christian Bay <christian.bay@studium.fau.de>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Martin Gumbrecht <martin.gumbrecht@googlemail.com>,
        Luis Ortega <luiorpe1@gmail.com>, Joe Perches <joe@perches.com>,
        Lilis Iskandar <veeableful@gmail.com>, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Khoa Mai <mdk194@gmail.com>
Subject: [PATCH 2/2] staging: bcm: Qos.c: Fix coding style
Date: Fri, 18 Jul 2014 04:45:05 +0300
Message-Id: <1405647905-21092-2-git-send-email-mdk194@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405647905-21092-1-git-send-email-mdk194@gmail.com>
References: <1405647905-21092-1-git-send-email-mdk194@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch and case should be in same indent level

Signed-off-by: Khoa Mai <mdk194@gmail.com>
---
 drivers/staging/bcm/Qos.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index e3cbcb1..0eb78a8 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -438,26 +438,26 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff *skb)
 	EThCSGetPktInfo(Adapter, pvEThPayload, &stEthCsPktInfo);
 
 	switch (stEthCsPktInfo.eNwpktEthFrameType) {
-		case eEth802LLCFrame:
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLCFrame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_frame);
-			break;
-		case eEth802LLCSNAPFrame:
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLC SNAP Frame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_snap_frame);
-			break;
-		case eEth802QVLANFrame:
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802.1Q VLANFrame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_q_frame);
-			break;
-		case eEthOtherFrame:
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : ETH Other Frame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
-			break;
-		default:
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : Unrecognized ETH Frame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
-			break;
+	case eEth802LLCFrame:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLCFrame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_frame);
+		break;
+	case eEth802LLCSNAPFrame:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLC SNAP Frame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_snap_frame);
+		break;
+	case eEth802QVLANFrame:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802.1Q VLANFrame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_eth_q_frame);
+		break;
+	case eEthOtherFrame:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : ETH Other Frame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
+		break;
+	default:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : Unrecognized ETH Frame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
+		break;
 	}
 
 	if (stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet) {
-- 
2.0.1

