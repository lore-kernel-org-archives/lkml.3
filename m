Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbaJINye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:54:34 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38051 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbaJINyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:54:15 -0400
From: Jia He <hejianet@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jia He <hejianet@gmail.com>
Subject: [PATCH 1/2] staging: rtl8188eu: Fix coding style space missing problems
Date: Thu,  9 Oct 2014 21:53:52 +0800
Message-Id: <1412862833-19015-2-git-send-email-hejianet@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412862833-19015-1-git-send-email-hejianet@gmail.com>
References: <1412845387-17668-1-git-send-email-hejianet@gmail.com>
 <1412862833-19015-1-git-send-email-hejianet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes space missing problems,eg. before '-', after ',', around
'|'

Signed-off-by: Jia He <hejianet@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/hal/bb_cfg.c | 4 ++--
 drivers/staging/rtl8188eu/hal/fw.c     | 4 ++--
 drivers/staging/rtl8188eu/hal/phy.c    | 2 +-
 drivers/staging/rtl8188eu/hal/rf.c     | 2 +-
 drivers/staging/rtl8188eu/hal/rf_cfg.c | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/bb_cfg.c b/drivers/staging/rtl8188eu/hal/bb_cfg.c
index 80e8cc9..3743a72 100644
--- a/drivers/staging/rtl8188eu/hal/bb_cfg.c
+++ b/drivers/staging/rtl8188eu/hal/bb_cfg.c
@@ -173,7 +173,7 @@ static bool set_baseband_agc_config(struct adapter *adapt)
 		u32 v1 = array[i];
 		u32 v2 = array[i+1];
 
-		if (v1 < 0xCDCDCDCD){
+		if (v1 < 0xCDCDCDCD) {
 			phy_set_bb_reg(adapt, v1, bMaskDWord, v2);
 			udelay(1);
 		}
@@ -552,7 +552,7 @@ static void store_pwrindex_offset(struct adapter *Adapter, u32 regaddr, u32 bitm
 	}
 }
 
-static void rtl_addr_delay(struct adapter *adapt, u32 addr, u32 bit_mask ,u32 data)
+static void rtl_addr_delay(struct adapter *adapt, u32 addr, u32 bit_mask , u32 data)
 {
 	if (addr == 0xfe) {
 		msleep(50);
diff --git a/drivers/staging/rtl8188eu/hal/fw.c b/drivers/staging/rtl8188eu/hal/fw.c
index 17b7f37..d6efd54 100644
--- a/drivers/staging/rtl8188eu/hal/fw.c
+++ b/drivers/staging/rtl8188eu/hal/fw.c
@@ -193,13 +193,13 @@ int rtl88eu_download_fw(struct adapter *adapt)
 	u32 fwsize;
 	int err;
 
-	if (request_firmware(&fw, fw_name, device)){
+	if (request_firmware(&fw, fw_name, device)) {
 		dev_err(device, "Firmware %s not available\n", fw_name);
 		return -ENOENT;
 	}
 
 	if (fw->size > FW_8188E_SIZE) {
-		dev_err(device,"Firmware size exceed 0x%X. Check it.\n",
+		dev_err(device, "Firmware size exceed 0x%X. Check it.\n",
 			 FW_8188E_SIZE);
 		return -1;
 	}
diff --git a/drivers/staging/rtl8188eu/hal/phy.c b/drivers/staging/rtl8188eu/hal/phy.c
index c4f7f35..3f663fe 100644
--- a/drivers/staging/rtl8188eu/hal/phy.c
+++ b/drivers/staging/rtl8188eu/hal/phy.c
@@ -478,7 +478,7 @@ void rtl88eu_dm_txpower_tracking_callback_thermalmeter(struct adapter *adapt)
 		/* 2.4G, decrease power */
 		{0, 0, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9, 10, 10, 11},
 		/* 2.4G, increase power */
-		{0, 0, -1, -2, -3, -4,-4, -4, -4, -5, -7, -8,-9, -9, -10},
+		{0, 0, -1, -2, -3, -4, -4, -4, -4, -5, -7, -8, -9, -9, -10},
 	};
 	u8 thermal_mapping[2][index_mapping_NUM_88E] = {
 		/* 2.4G, decrease power */
diff --git a/drivers/staging/rtl8188eu/hal/rf.c b/drivers/staging/rtl8188eu/hal/rf.c
index c2fac34..eea4c8a 100644
--- a/drivers/staging/rtl8188eu/hal/rf.c
+++ b/drivers/staging/rtl8188eu/hal/rf.c
@@ -131,7 +131,7 @@ void rtl88eu_phy_rf6052_set_cck_txpower(struct adapter *adapt, u8 *powerlevel)
 /*  powerbase1 for HT MCS rates */
 static void getpowerbase88e(struct adapter *adapt, u8 *pwr_level_ofdm,
 			    u8 *pwr_level_bw20, u8 *pwr_level_bw40,
-			    u8 channel,u32 *ofdmbase, u32 *mcs_base)
+			    u8 channel, u32 *ofdmbase, u32 *mcs_base)
 {
 	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
 	u32 powerbase0, powerbase1;
diff --git a/drivers/staging/rtl8188eu/hal/rf_cfg.c b/drivers/staging/rtl8188eu/hal/rf_cfg.c
index ddc2f55..5dc11ca 100644
--- a/drivers/staging/rtl8188eu/hal/rf_cfg.c
+++ b/drivers/staging/rtl8188eu/hal/rf_cfg.c
@@ -164,7 +164,7 @@ do {								\
 #define B3WIREDATALENGTH 0x800
 #define BRFSI_RFENV 0x10
 
-static void rtl_rfreg_delay(struct adapter *adapt, enum rf_radio_path rfpath,u32 addr, u32 mask, u32 data)
+static void rtl_rfreg_delay(struct adapter *adapt, enum rf_radio_path rfpath, u32 addr, u32 mask, u32 data)
 {
 	if (addr == 0xfe) {
 		mdelay(50);
@@ -190,7 +190,7 @@ static void rtl8188e_config_rf_reg(struct adapter *adapt,
 	u32 content = 0x1000; /*RF Content: radio_a_txt*/
 	u32 maskforphyset = (u32)(content & 0xE000);
 
-	rtl_rfreg_delay(adapt, RF90_PATH_A, addr| maskforphyset,
+	rtl_rfreg_delay(adapt, RF90_PATH_A, addr | maskforphyset,
 			RFREG_OFFSET_MASK,
 			data);
 }
-- 
1.9.3

