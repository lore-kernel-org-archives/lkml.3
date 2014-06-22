Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaFVIVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:21:53 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58089 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaFVIVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:21:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/42] staging: rtl8188eu: Remove dummy function Hal_InitChannelPlan()
Date: Sun, 22 Jun 2014 13:49:26 +0530
Message-Id: <1403425202-11942-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    4 ----
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |    4 ----
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    1 -
 3 files changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index bee20a0..0094d21 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1079,10 +1079,6 @@ void Hal_ReadThermalMeter_88E(struct adapter *Adapter, u8 *PROMContent, bool Aut
 	DBG_88E("ThermalMeter = 0x%x\n", pHalData->EEPROMThermalMeter);
 }
 
-void Hal_InitChannelPlan(struct adapter *padapter)
-{
-}
-
 bool HalDetectPwrDownMode88E(struct adapter *Adapter)
 {
 	u8 tmpvalue = 0;
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 8c26d0a..5096d4d 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1149,10 +1149,6 @@ readAdapterInfo_8188EU(
 	Hal_EfuseParseBoardType88E(adapt, eeprom->efuse_eeprom_data, eeprom->bautoload_fail_flag);
 	Hal_ReadThermalMeter_88E(adapt, eeprom->efuse_eeprom_data, eeprom->bautoload_fail_flag);
 
-	/*  */
-	/*  The following part initialize some vars by PG info. */
-	/*  */
-	Hal_InitChannelPlan(adapt);
 }
 
 static void _ReadPROMContent(
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index 94a5f93..ed3204f 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -457,7 +457,6 @@ void Hal_ReadPowerSavingMode88E(struct adapter *pAdapter, u8 *hwinfo,
 
 bool HalDetectPwrDownMode88E(struct adapter *Adapter);
 
-void Hal_InitChannelPlan(struct adapter *padapter);
 void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc);
 
 /*  register */
-- 
1.7.10.4

