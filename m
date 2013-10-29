Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3J2DwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:52:09 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:56033 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab3J2DwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:52:03 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 08/11 V2] Staging: bcm: Replace UINT32 with u32 in Adapter.h
Date: Mon, 28 Oct 2013 23:51:45 -0400
Message-Id: <1383018708-29615-9-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
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
index f7620ab..35f480a 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -94,7 +94,7 @@ struct bcm_classifier_rule {
 	/* For IPv6 Addressing */
 	u8	ucDirection;
 	bool		bIpv6Protocol;
-	UINT32		u32PHSRuleID;
+	u32		u32PHSRuleID;
 	struct bcm_phs_rule sPhsRule;
 	u8	u8AssociatedPHSI;
 
@@ -340,11 +340,11 @@ struct bcm_mini_adapter {
 	bool			AutoFirmDld;
 	bool			bMipsConfig;
 	bool			bDPLLConfig;
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
 	bool			bDoSuspend;
 	UINT			syscfgBefFwDld;
 	bool			StopAllXaction;
-	UINT32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
+	u32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
 	struct semaphore	LowPowerModeSync;
 	unsigned long		liDrainCalculated;
 	UINT			gpioBitMap;
-- 
1.7.9.5

