Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaIBAcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:32:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48042 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaIBAau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:50 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 06/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:30 -0400
Message-Id: <1409617776-30730-6-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove whitespace after open parenthesis '('.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index a478ee4..b0326c9 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -133,7 +133,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 	if (level_num == 2) {
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_1_MEDIUM;
 
-		if ( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
+		if ((rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
 			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_LOW)) {
 			if (undecoratedsmoothed_pwdb >= (rssi_thresh + BT_FW_COEX_THRESH_TOL)) {
 				bt_rssi_state = BT_RSSI_STATE_HIGH;
@@ -161,7 +161,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 			return rtlpcipriv->btcoexist.bt_pre_rssi_state;
 		}
 
-		if ( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
+		if ((rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
 			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_LOW)) {
 			if (undecoratedsmoothed_pwdb >= (rssi_thresh+BT_FW_COEX_THRESH_TOL)) {
 				bt_rssi_state = BT_RSSI_STATE_MEDIUM;
@@ -173,7 +173,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
 				bt_rssi_state = BT_RSSI_STATE_STAY_LOW;
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE, ("[DM][BT], RSSI_1 state stay at Low\n"));
 			}
-		} else if ( (rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_MEDIUM) ||
+		} else if ((rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_MEDIUM) ||
 			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_MEDIUM)) {
 			if (undecoratedsmoothed_pwdb >= (rssi_thresh1 + BT_FW_COEX_THRESH_TOL)) {
 				bt_rssi_state = BT_RSSI_STATE_HIGH;
-- 
2.1.0

