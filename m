Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaIBAaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:30:46 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:38532 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaIBAao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:44 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 02/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:26 -0400
Message-Id: <1409617776-30730-2-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue which requires a space before the open
curly brace '{'.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index cff300c..b9afcfc 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -43,7 +43,7 @@ void rtl8821ae_dm_bt_reject_ap_aggregated_packet(struct ieee80211_hw *hw, bool b
 	struct rtl_priv rtlpriv = rtl_priv(hw);
 	PRX_TS_RECORD			pRxTs = NULL;
 
-	if(b_reject){
+	if(b_reject) {
 		/* Do not allow receiving A-MPDU aggregation. */
 		if (rtlpriv->mac80211.vendor == PEER_CISCO) {
 				if (pHTInfo->bAcceptAddbaReq) {
@@ -224,7 +224,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state(struct ieee80211_hw *hw,
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_RSSI_MEDIUM;
 
 		if ((rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_LOW) ||
-			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_LOW)){
+			(rtlpcipriv->btcoexist.bt_pre_rssi_state == BT_RSSI_STATE_STAY_LOW)) {
 			if (undecoratedsmoothed_pwdb
 				>= (rssi_thresh + BT_FW_COEX_THRESH_TOL)) {
 				bt_rssi_state = BT_RSSI_STATE_HIGH;
-- 
2.1.0

