Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaIBAcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:32:04 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:42372 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaIBAax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:53 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 08/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:32 -0400
Message-Id: <1409617776-30730-8-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue where the if statement unnecessarily uses curly
braces for one line statements.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index 938c98a..f1cf373 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -78,17 +78,15 @@ struct rtl_phy *rtlphy = &(rtlpriv->phy);
 if (rtlpriv->link_info.b_busytraffic) {
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_IDLE;
 
-	if (rtlpriv->link_info.b_tx_busy_traffic) {
+	if (rtlpriv->link_info.b_tx_busy_traffic)
 		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_UPLINK;
-	} else {
+	else
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_UPLINK;
-	}
 
-	if (rtlpriv->link_info.b_rx_busy_traffic) {
+	if (rtlpriv->link_info.b_rx_busy_traffic)
 		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_DOWNLINK;
-	} else {
+	else
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_DOWNLINK;
-	}
 } else {
 	rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_IDLE;
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_UPLINK;
@@ -111,12 +109,11 @@ if (rtlpriv->mac80211.mode == WIRELESS_MODE_G
 	}
 }
 
-if (bt_operation_on) {
+if (bt_operation_on)
 	rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_BT30;
-} else {
+else
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_BT30;
 }
-}
 
 
 u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
-- 
2.1.0

