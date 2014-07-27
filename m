Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaG0I0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 04:26:51 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50218 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaG0I0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 04:26:49 -0400
From: Zahari Doychev <zahari.doychev@linux.com>
To: lisa@xenapiadmin.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Subject: [PATCH] [staging] bcm: fix code style
Date: Sun, 27 Jul 2014 10:26:40 +0200
Message-Id: <a282e256c7ec143dea88ca3aeeeb959ace7636a2.1406448840.git.zahari.doychev@linux.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes some errors and warnings reported by checkpatch.pl

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
---
 drivers/staging/bcm/PHSModule.h | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/bcm/PHSModule.h b/drivers/staging/bcm/PHSModule.h
index d697f9c..d84d60b 100644
--- a/drivers/staging/bcm/PHSModule.h
+++ b/drivers/staging/bcm/PHSModule.h
@@ -20,28 +20,37 @@ int PHSReceive(struct bcm_mini_adapter *Adapter,
 
 void DumpDataPacketHeader(PUCHAR pPkt);
 
-void DumpFullPacket(UCHAR *pBuf,UINT nPktLen);
+void DumpFullPacket(UCHAR *pBuf, UINT nPktLen);
 
 void DumpPhsRules(struct bcm_phs_extension *pDeviceExtension);
 
 
-int phs_init(struct bcm_phs_extension *pPhsdeviceExtension,struct bcm_mini_adapter *Adapter);
+int phs_init(struct bcm_phs_extension *pPhsdeviceExtension,
+	     struct bcm_mini_adapter *Adapter);
 
 int PhsCleanup(struct bcm_phs_extension *pPHSDeviceExt);
 
-//Utility Functions
-ULONG PhsUpdateClassifierRule(void* pvContext,B_UINT16 uiVcid,B_UINT16 uiClsId, struct bcm_phs_rule *psPhsRule,B_UINT8  u8AssociatedPHSI );
+/* Utility Functions */
+ULONG PhsUpdateClassifierRule(void *pvContext,
+			      B_UINT16 uiVcid,
+			      B_UINT16 uiClsId,
+			      struct bcm_phs_rule *psPhsRule,
+			      B_UINT8  u8AssociatedPHSI);
 
-ULONG PhsDeletePHSRule(void* pvContext,B_UINT16 uiVcid,B_UINT8 u8PHSI);
+ULONG PhsDeletePHSRule(void *pvContext, B_UINT16 uiVcid, B_UINT8 u8PHSI);
 
-ULONG PhsDeleteClassifierRule(void* pvContext, B_UINT16 uiVcid ,B_UINT16  uiClsId);
+ULONG PhsDeleteClassifierRule(void *pvContext,
+			      B_UINT16 uiVcid,
+			      B_UINT16  uiClsId);
 
-ULONG PhsDeleteSFRules(void* pvContext,B_UINT16 uiVcid) ;
+ULONG PhsDeleteSFRules(void *pvContext, B_UINT16 uiVcid);
 
 
 bool ValidatePHSRule(struct bcm_phs_rule *psPhsRule);
 
-UINT GetServiceFlowEntry(struct bcm_phs_table *psServiceFlowTable,B_UINT16 uiVcid, struct bcm_phs_entry **ppstServiceFlowEntry);
+UINT GetServiceFlowEntry(struct bcm_phs_table *psServiceFlowTable,
+			 B_UINT16 uiVcid,
+			 struct bcm_phs_entry **ppstServiceFlowEntry);
 
 
 void DumpPhsRules(struct bcm_phs_extension *pDeviceExtension);
-- 
1.9.1

