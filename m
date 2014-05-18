Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaERPY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:24:29 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43543 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaERPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:24:27 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 17/28] staging: rtl8188eu: Remove function odm_DynamicBBPowerSaving()
Date: Sun, 18 May 2014 20:49:10 +0530
Message-Id: <1400426361-19596-18-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

odm_DynamicBBPowerSaving() has empty defination.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index d8482ab..2e105b4 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -183,7 +183,6 @@ void ODM_DMInit(struct odm_dm_struct *pDM_Odm)
 	odm_RateAdaptiveMaskInit(pDM_Odm);
 
 	odm_PrimaryCCA_Init(pDM_Odm);    /*  Gary */
-	odm_DynamicBBPowerSavingInit(pDM_Odm);
 	odm_DynamicTxPowerInit(pDM_Odm);
 	odm_TXPowerTrackingInit(pDM_Odm);
 	ODM_EdcaTurboInit(pDM_Odm);
@@ -215,7 +214,6 @@ void ODM_DMWatchdog(struct odm_dm_struct *pDM_Odm)
 
 	odm_RefreshRateAdaptiveMask(pDM_Odm);
 
-	odm_DynamicBBPowerSaving(pDM_Odm);
 	odm_DynamicPrimaryCCA(pDM_Odm);
 	if ((pDM_Odm->AntDivType ==  CG_TRX_HW_ANTDIV)	||
 	    (pDM_Odm->AntDivType == CGCS_RX_HW_ANTDIV)	||
@@ -865,10 +863,6 @@ void odm_DynamicBBPowerSavingInit(struct odm_dm_struct *pDM_Odm)
 	pDM_PSTable->initialize = 0;
 }
 
-void odm_DynamicBBPowerSaving(struct odm_dm_struct *pDM_Odm)
-{
-}
-
 void odm_1R_CCA(struct odm_dm_struct *pDM_Odm)
 {
 	struct adapter *adapter = pDM_Odm->Adapter;
-- 
1.7.10.4

