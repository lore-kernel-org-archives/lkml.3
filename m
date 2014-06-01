Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbaFAMRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:17:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47733 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbaFAMRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:17:45 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/26] staging: rtl8188eu: Remove function with empty defination ODM_ResetIQKResult()
Date: Sun,  1 Jun 2014 17:46:27 +0530
Message-Id: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalPhyRf.c       |    8 --------
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c |    2 --
 drivers/staging/rtl8188eu/include/HalPhyRf.h   |    2 --
 3 files changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf.c b/drivers/staging/rtl8188eu/hal/HalPhyRf.c
index 980f7da..5dd25e5 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf.c
@@ -20,14 +20,6 @@
 
  #include "odm_precomp.h"
 
-/* 3============================================================ */
-/* 3 IQ Calibration */
-/* 3============================================================ */
-
-void ODM_ResetIQKResult(struct odm_dm_struct *pDM_Odm)
-{
-}
-
 u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
 {
 	u8	channel_all[ODM_TARGET_CHNL_NUM_2G_5G] = {
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 7c22658..2bcb39f 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -455,8 +455,6 @@ odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 		}
 
 		if (delta_IQK >= 8) { /*  Delta temperature is equal to or larger than 20 centigrade. */
-			ODM_ResetIQKResult(dm_odm);
-
 			dm_odm->RFCalibrateInfo.ThermalValue_IQK = ThermalValue;
 			PHY_IQCalibrate_8188E(Adapter, false);
 		}
diff --git a/drivers/staging/rtl8188eu/include/HalPhyRf.h b/drivers/staging/rtl8188eu/include/HalPhyRf.h
index 1ec4971..8ca6ce6 100644
--- a/drivers/staging/rtl8188eu/include/HalPhyRf.h
+++ b/drivers/staging/rtl8188eu/include/HalPhyRf.h
@@ -23,8 +23,6 @@
 
 #define ODM_TARGET_CHNL_NUM_2G_5G	59
 
-void ODM_ResetIQKResult(struct odm_dm_struct *pDM_Odm);
-
 u8 ODM_GetRightChnlPlaceforIQK(u8 chnl);
 
 #endif	/*  #ifndef __HAL_PHY_RF_H__ */
-- 
1.7.10.4

