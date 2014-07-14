Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaGNONg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:13:36 -0400
Received: from webmail2.sr-online.de ([213.147.7.111]:59603 "EHLO
	webmail2.sr-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaGNON1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:13:27 -0400
From: "Joerg C. Meyer" <joerg@meyer.homedns.org>
To: gregkh@linuxfoundation.org, dingtianhong@huawei.com,
        chenweilong@huawei.com, sachin.kamat@linaro.org, davem@davemloft.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Joerg C. Meyer" <joerg@meyer.homedns.org>
Subject: [PATCH] Staging: rtl8821ae: fix comment coding style issue in cam.c
Date: Mon, 14 Jul 2014 16:13:25 +0200
Message-Id: <1405347205-3364-1-git-send-email-joerg@meyer.homedns.org>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cam.c file that removes some obsolete C99 style comments

Signed-off-by: Joerg C. Meyer <joerg@meyer.homedns.org>

---
 drivers/staging/rtl8821ae/cam.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8821ae/cam.c b/drivers/staging/rtl8821ae/cam.c
index 3bc6b3d..6185ea4 100644
--- a/drivers/staging/rtl8821ae/cam.c
+++ b/drivers/staging/rtl8821ae/cam.c
@@ -152,7 +152,6 @@ u8 rtl_cam_add_one_entry(struct ieee80211_hw *hw, u8 *mac_addr,
 	return 1;
 
 }
-//EXPORT_SYMBOL(rtl_cam_add_one_entry);
 
 int rtl_cam_delete_one_entry(struct ieee80211_hw *hw,
 			     u8 *mac_addr, u32 ul_key_id)
@@ -176,7 +175,6 @@ int rtl_cam_delete_one_entry(struct ieee80211_hw *hw,
 	return 0;
 
 }
-//EXPORT_SYMBOL(rtl_cam_delete_one_entry);
 
 void rtl_cam_reset_all_entry(struct ieee80211_hw *hw)
 {
@@ -186,7 +184,6 @@ void rtl_cam_reset_all_entry(struct ieee80211_hw *hw)
 	ul_command = BIT(31) | BIT(30);
 	rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 }
-//EXPORT_SYMBOL(rtl_cam_reset_all_entry);
 
 void rtl_cam_mark_invalid(struct ieee80211_hw *hw, u8 uc_index)
 {
@@ -227,7 +224,6 @@ void rtl_cam_mark_invalid(struct ieee80211_hw *hw, u8 uc_index)
 	RT_TRACE(COMP_SEC, DBG_DMESG,
 		 ("rtl_cam_mark_invalid(): WRITE A0: %x \n", ul_command));
 }
-//EXPORT_SYMBOL(rtl_cam_mark_invalid);
 
 void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
 {
@@ -281,7 +277,6 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
 	}
 
 }
-//EXPORT_SYMBOL(rtl_cam_empty_entry);
 
 u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 {
@@ -316,7 +311,6 @@ u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	}
 	return TOTAL_CAM_ENTRY;
 }
-//EXPORT_SYMBOL(rtl_cam_get_free_entry);
 
 void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 {
@@ -349,4 +343,3 @@ void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	}
 	return;
 }
-//EXPORT_SYMBOL(rtl_cam_del_entry);
-- 
2.0.1

