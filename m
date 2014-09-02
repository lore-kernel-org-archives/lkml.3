Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaIBAav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:30:51 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:59690 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaIBAar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:47 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 04/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:28 -0400
Message-Id: <1409617776-30730-4-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue which requires a space after a comma.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c   | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index bce3771..48c6160 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -197,7 +197,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 				rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_RSSI_1_MEDIUM;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_HIGH;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_LOW;
-				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,("[DM][BT], RSSI_1 state switch to Medium\n"));
+				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 state switch to Medium\n"));
 			} else {
 				bt_rssi_state = BT_RSSI_STATE_STAY_HIGH;
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 state stay at High\n"));
@@ -382,11 +382,11 @@ void rtl8821ae_dm_bt_agc_table(struct ieee80211_hw *hw, u8 type)
 
 	if (type == BT_AGCTABLE_OFF) {
 		RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[BT]AGCTable Off!\n"));
-		rtl_write_dword(rtlpriv, 0xc78,0x641c0001);
-		rtl_write_dword(rtlpriv, 0xc78,0x631d0001);
-		rtl_write_dword(rtlpriv, 0xc78,0x621e0001);
-		rtl_write_dword(rtlpriv, 0xc78,0x611f0001);
-		rtl_write_dword(rtlpriv, 0xc78,0x60200001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x641c0001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x631d0001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x621e0001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x611f0001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x60200001);
 
 		rtl8821ae_phy_set_rf_reg(hw, RF90_PATH_A,
 					RF_RX_AGC_HP, 0xfffff, 0x32000);
@@ -400,11 +400,11 @@ void rtl8821ae_dm_bt_agc_table(struct ieee80211_hw *hw, u8 type)
 					RF_RX_G1, 0xfffff, 0x30355);
 	} else if (type == BT_AGCTABLE_ON) {
 		RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[BT]AGCTable On!\n"));
-		rtl_write_dword(rtlpriv, 0xc78,0x4e1c0001);
-		rtl_write_dword(rtlpriv, 0xc78,0x4d1d0001);
-		rtl_write_dword(rtlpriv, 0xc78,0x4c1e0001);
-		rtl_write_dword(rtlpriv, 0xc78,0x4b1f0001);
-		rtl_write_dword(rtlpriv, 0xc78,0x4a200001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x4e1c0001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x4d1d0001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x4c1e0001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x4b1f0001);
+		rtl_write_dword(rtlpriv, 0xc78, 0x4a200001);
 
 		rtl8821ae_phy_set_rf_reg(hw, RF90_PATH_A,
 					RF_RX_AGC_HP, 0xfffff, 0xdc000);
@@ -428,10 +428,10 @@ void rtl8821ae_dm_bt_bb_back_off_level(struct ieee80211_hw *hw, u8 type)
 
 	if (type == BT_BB_BACKOFF_OFF) {
 		RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[BT]BBBackOffLevel Off!\n"));
-		rtl_write_dword(rtlpriv, 0xc04,0x3a05611);
+		rtl_write_dword(rtlpriv, 0xc04, 0x3a05611);
 	} else if (type == BT_BB_BACKOFF_ON) {
 		RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[BT]BBBackOffLevel On!\n"));
-		rtl_write_dword(rtlpriv, 0xc04,0x3a07611);
+		rtl_write_dword(rtlpriv, 0xc04, 0x3a07611);
 		rtlpcipriv->btcoexist.b_sw_coexist_all_off = false;
 	}
 }
-- 
2.1.0

