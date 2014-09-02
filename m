Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaIBAat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:30:49 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61634 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaIBAaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:46 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 03/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:27 -0400
Message-Id: <1409617776-30730-3-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue which requires a space after the open
parenthesis '('.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c   | 50 +++++++++++-----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index b9afcfc..bce3771 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -43,13 +43,13 @@ void rtl8821ae_dm_bt_reject_ap_aggregated_packet(struct ieee80211_hw *hw, bool b
 	struct rtl_priv rtlpriv = rtl_priv(hw);
 	PRX_TS_RECORD			pRxTs = NULL;
 
-	if(b_reject) {
+	if (b_reject) {
 		/* Do not allow receiving A-MPDU aggregation. */
 		if (rtlpriv->mac80211.vendor == PEER_CISCO) {
 				if (pHTInfo->bAcceptAddbaReq) {
 					RTPRINT(FBT, BT_TRACE, ("BT_Disallow AMPDU \n"));
 					pHTInfo->bAcceptAddbaReq = FALSE;
-					if(GetTs(Adapter, (PTS_COMMON_INFO*)(&pRxTs), pMgntInfo->Bssid, 0, RX_DIR, FALSE))
+					if (GetTs(Adapter, (PTS_COMMON_INFO*)(&pRxTs), pMgntInfo->Bssid, 0, RX_DIR, FALSE))
 						TsInitDelBA(Adapter, (PTS_COMMON_INFO)pRxTs, RX_DIR);
 				}
 			} else {
@@ -59,7 +59,7 @@ void rtl8821ae_dm_bt_reject_ap_aggregated_packet(struct ieee80211_hw *hw, bool b
 				}
 			}
 		} else {
-			if(rtlpriv->mac80211.vendor == PEER_CISCO) {
+			if (rtlpriv->mac80211.vendor == PEER_CISCO) {
 				if (!pHTInfo->bAcceptAddbaReq) {
 					RTPRINT(FBT, BT_TRACE, ("BT_Allow AMPDU \n"));
 					pHTInfo->bAcceptAddbaReq = TRUE;
@@ -78,13 +78,13 @@ struct rtl_phy *rtlphy = &(rtlpriv->phy);
 if (rtlpriv->link_info.b_busytraffic) {
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_IDLE;
 
-	if(rtlpriv->link_info.b_tx_busy_traffic) {
+	if (rtlpriv->link_info.b_tx_busy_traffic) {
 		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_UPLINK;
 	} else {
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_UPLINK;
 	}
 
-	if(rtlpriv->link_info.b_rx_busy_traffic) {
+	if (rtlpriv->link_info.b_rx_busy_traffic) {
 		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_DOWNLINK;
 	} else {
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_DOWNLINK;
@@ -102,7 +102,7 @@ if (rtlpriv->mac80211.mode == WIRELESS_MODE_G
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_HT40;
 } else {
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_LEGACY;
-	if(rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
+	if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
 		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_HT40;
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_HT20;
 	} else {
@@ -130,12 +130,12 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 
 	undecoratedsmoothed_pwdb =  rtl8821ae_dm_bt_get_rx_ss(hw);
 
-	if(level_num == 2) {
+	if (level_num == 2) {
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_MEDIUM;
 
-		if( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
+		if ( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
 			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_LOW)) {
-			if(undecoratedsmoothed_pwdb >= (rssi_thresh + BT_FW_COEX_THRESH_TOL)) {
+			if (undecoratedsmoothed_pwdb >= (rssi_thresh + BT_FW_COEX_THRESH_TOL)) {
 				bt_rssi_state = BT_RSSI_STATE_HIGH;
 				rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_RSSI_1_HIGH;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_LOW;
@@ -145,7 +145,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 state stay at Low\n"));
 			}
 		} else {
-			if(undecoratedsmoothed_pwdb < rssi_thresh) {
+			if (undecoratedsmoothed_pwdb < rssi_thresh) {
 				bt_rssi_state = BT_RSSI_STATE_LOW;
 				rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_RSSI_1_LOW;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_HIGH;
@@ -155,15 +155,15 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 state stay at High\n"));
 			}
 		}
-	} else if(level_num == 3) {
-		if(rssi_thresh > rssi_thresh1) {
+	} else if (level_num == 3) {
+		if (rssi_thresh > rssi_thresh1) {
 			RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 thresh error!!\n"));
 			return rtlpcipriv->btcoexist.bt_pre_rssi_state;
 		}
 
-		if( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
+		if ( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
 			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_LOW)) {
-			if(undecoratedsmoothed_pwdb >= (rssi_thresh+BT_FW_COEX_THRESH_TOL)) {
+			if (undecoratedsmoothed_pwdb >= (rssi_thresh+BT_FW_COEX_THRESH_TOL)) {
 				bt_rssi_state = BT_RSSI_STATE_MEDIUM;
 				rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_RSSI_1_MEDIUM;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_LOW;
@@ -173,15 +173,15 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 				bt_rssi_state = BT_RSSI_STATE_STAY_LOW;
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 state stay at Low\n"));
 			}
-		} else if( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_MEDIUM) ||
+		} else if ( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_MEDIUM) ||
 			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_MEDIUM)) {
-			if(undecoratedsmoothed_pwdb >= (rssi_thresh1 + BT_FW_COEX_THRESH_TOL)) {
+			if (undecoratedsmoothed_pwdb >= (rssi_thresh1 + BT_FW_COEX_THRESH_TOL)) {
 				bt_rssi_state = BT_RSSI_STATE_HIGH;
 				rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_RSSI_1_HIGH;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_LOW;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_MEDIUM;
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 state switch to High\n"));
-			} else if(undecoratedsmoothed_pwdb < rssi_thresh) {
+			} else if (undecoratedsmoothed_pwdb < rssi_thresh) {
 				bt_rssi_state = BT_RSSI_STATE_LOW;
 				rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_RSSI_1_LOW;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_HIGH;
@@ -192,7 +192,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 state stay at Medium\n"));
 			}
 		} else {
-			if(undecoratedsmoothed_pwdb < rssi_thresh1) {
+			if (undecoratedsmoothed_pwdb < rssi_thresh1) {
 				bt_rssi_state = BT_RSSI_STATE_MEDIUM;
 				rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_RSSI_1_MEDIUM;
 				rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_HIGH;
@@ -263,7 +263,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state(struct ieee80211_hw *hw,
 		}
 		if ((rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
 			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_LOW)) {
-			if(undecoratedsmoothed_pwdb
+			if (undecoratedsmoothed_pwdb
 				>= (rssi_thresh + BT_FW_COEX_THRESH_TOL)) {
 				bt_rssi_state = BT_RSSI_STATE_MEDIUM;
 				rtlpcipriv->btcoexist.current_state
@@ -292,7 +292,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state(struct ieee80211_hw *hw,
 					&= ~BT_COEX_STATE_WIFI_RSSI_MEDIUM;
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 					("[DM][BT], RSSI state switch to High\n"));
-			} else if(undecoratedsmoothed_pwdb < rssi_thresh)
+			} else if (undecoratedsmoothed_pwdb < rssi_thresh)
 			{
 				bt_rssi_state = BT_RSSI_STATE_LOW;
 				rtlpcipriv->btcoexist.current_state
@@ -309,7 +309,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state(struct ieee80211_hw *hw,
 					("[DM][BT], RSSI state stay at Medium\n"));
 			}
 		} else {
-			if(undecoratedsmoothed_pwdb < rssi_thresh1) {
+			if (undecoratedsmoothed_pwdb < rssi_thresh1) {
 				bt_rssi_state = BT_RSSI_STATE_MEDIUM;
 				rtlpcipriv->btcoexist.current_state
 					|= BT_COEX_STATE_WIFI_RSSI_MEDIUM;
@@ -443,7 +443,7 @@ void rtl8821ae_dm_bt_fw_coex_all_off(struct ieee80211_hw *hw)
 	RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 		("rtl8821ae_dm_bt_fw_coex_all_off()\n"));
 
-	if(rtlpcipriv->btcoexist.b_fw_coexist_all_off)
+	if (rtlpcipriv->btcoexist.b_fw_coexist_all_off)
 		return;
 
 	RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
@@ -460,7 +460,7 @@ void rtl8821ae_dm_bt_sw_coex_all_off(struct ieee80211_hw *hw)
 	RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 		("rtl8821ae_dm_bt_sw_coex_all_off()\n"));
 
-	if(rtlpcipriv->btcoexist.b_sw_coexist_all_off)
+	if (rtlpcipriv->btcoexist.b_sw_coexist_all_off)
 		return;
 
 	RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
@@ -477,7 +477,7 @@ void rtl8821ae_dm_bt_hw_coex_all_off(struct ieee80211_hw *hw)
 	RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 		("rtl8821ae_dm_bt_hw_coex_all_off()\n"));
 
-	if(rtlpcipriv->btcoexist.b_hw_coexist_all_off)
+	if (rtlpcipriv->btcoexist.b_hw_coexist_all_off)
 		return;
 	RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 		("rtl8821ae_dm_bt_hw_coex_all_off(), real Do\n"));
@@ -498,7 +498,7 @@ bool rtl8821ae_dm_bt_is_coexist_state_changed(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 
-	if((rtlpcipriv->btcoexist.previous_state
+	if ((rtlpcipriv->btcoexist.previous_state
 		== rtlpcipriv->btcoexist.current_state)
 		&& (rtlpcipriv->btcoexist.previous_state_h
 		== rtlpcipriv->btcoexist.current_state_h))
-- 
2.1.0

