Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaG1RpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:45:11 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39503 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaG1Rln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:41:43 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 1/9] staging: rtl8188eu: Remove unused member MultiFunc from struct hal_data_8188e
Date: Mon, 28 Jul 2014 23:11:22 +0530
Message-Id: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    1 -
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 161138f..fbf70f6 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -517,7 +517,6 @@ static struct HAL_VERSION ReadChipVersion8188E(struct adapter *padapter)
 	pHalData->RegulatorMode = ((value32 & TRP_BT_EN) ? RT_LDO_REGULATOR : RT_SWITCHING_REGULATOR);
 
 	ChipVersion.ROMVer = 0;	/*  ROM code version. */
-	pHalData->MultiFunc = RT_MULTI_FUNC_NONE;
 
 	dump_chip_info(ChipVersion);
 
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index 4b7b069..fb20653 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -240,7 +240,6 @@ enum rt_regulator_mode {
 
 struct hal_data_8188e {
 	struct HAL_VERSION	VersionID;
-	enum rt_multi_func MultiFunc; /*  For multi-function consideration. */
 	enum rt_regulator_mode RegulatorMode; /*  switching regulator or LDO */
 	u16	CustomerID;
 
-- 
1.7.10.4

