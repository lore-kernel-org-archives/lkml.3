Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaERPYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:24:46 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59214 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaERPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:24:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/28] staging: rtl8188eu: Remove unused function odm_DynamicBBPowerSavingInit()
Date: Sun, 18 May 2014 20:49:11 +0530
Message-Id: <1400426361-19596-19-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 2e105b4..e8ad880 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -848,21 +848,6 @@ void ODM_Write_CCK_CCA_Thres(struct odm_dm_struct *pDM_Odm, u8 CurCCK_CCAThres)
 	pDM_DigTable->CurCCK_CCAThres = CurCCK_CCAThres;
 }
 
-/* 3============================================================ */
-/* 3 BB Power Save */
-/* 3============================================================ */
-void odm_DynamicBBPowerSavingInit(struct odm_dm_struct *pDM_Odm)
-{
-	struct rtl_ps *pDM_PSTable = &pDM_Odm->DM_PSTable;
-
-	pDM_PSTable->PreCCAState = CCA_MAX;
-	pDM_PSTable->CurCCAState = CCA_MAX;
-	pDM_PSTable->PreRFState = RF_MAX;
-	pDM_PSTable->CurRFState = RF_MAX;
-	pDM_PSTable->Rssi_val_min = 0;
-	pDM_PSTable->initialize = 0;
-}
-
 void odm_1R_CCA(struct odm_dm_struct *pDM_Odm)
 {
 	struct adapter *adapter = pDM_Odm->Adapter;
-- 
1.7.10.4

