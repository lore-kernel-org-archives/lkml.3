Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3JZGQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:16:08 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:48451 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3JZGPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:34 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 08/11] Staging: bcm: Replace UINT32 with u32 in Adapter.h
Date: Sat, 26 Oct 2013 02:15:17 -0400
Message-Id: <1382768120-23380-8-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces "UINT32" with "u32"
in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 27b5011..eeeea34 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -94,7 +94,7 @@ struct bcm_classifier_rule {
 	/* For IPv6 Addressing */
 	unsigned char	ucDirection;
 	BOOLEAN		bIpv6Protocol;
-	UINT32		u32PHSRuleID;
+	u32		u32PHSRuleID;
 	struct bcm_phs_rule sPhsRule;
 	unsigned char		u8AssociatedPHSI;
 
@@ -340,11 +340,11 @@ struct bcm_mini_adapter {
 	BOOLEAN			AutoFirmDld;
 	BOOLEAN			bMipsConfig;
 	BOOLEAN			bDPLLConfig;
-	UINT32			aTxPktSizeHist[MIBS_MAX_HIST_ENTRIES];
-	UINT32			aRxPktSizeHist[MIBS_MAX_HIST_ENTRIES];
+	u32			aTxPktSizeHist[MIBS_MAX_HIST_ENTRIES];
+	u32			aRxPktSizeHist[MIBS_MAX_HIST_ENTRIES];
 	struct bcm_fragmented_packet_info astFragmentedPktClassifierTable[MAX_FRAGMENTEDIP_CLASSIFICATION_ENTRIES];
 	atomic_t		uiMBupdate;
-	UINT32			PmuMode;
+	u32			PmuMode;
 	enum bcm_nvm_type	eNVMType;
 	UINT			uiSectorSize;
 	UINT			uiSectorSizeInCFG;
@@ -388,7 +388,7 @@ struct bcm_mini_adapter {
 	BOOLEAN			bDoSuspend;
 	UINT			syscfgBefFwDld;
 	BOOLEAN			StopAllXaction;
-	UINT32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
+	u32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
 	struct semaphore	LowPowerModeSync;
 	unsigned long		liDrainCalculated;
 	UINT			gpioBitMap;
-- 
1.7.9.5

