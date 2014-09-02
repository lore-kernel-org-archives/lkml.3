Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaIBAay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:30:54 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:44796 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaIBAav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:51 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 07/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:31 -0400
Message-Id: <1409617776-30730-7-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary whitespace before a quoted newline.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index b0326c9..938c98a 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -47,7 +47,7 @@ void rtl8821ae_dm_bt_reject_ap_aggregated_packet(struct ieee80211_hw *hw, bool b
 		/* Do not allow receiving A-MPDU aggregation. */
 		if (rtlpriv->mac80211.vendor == PEER_CISCO) {
 				if (pHTInfo->bAcceptAddbaReq) {
-					RTPRINT(FBT, BT_TRACE, ("BT_Disallow AMPDU \n"));
+					RTPRINT(FBT, BT_TRACE, ("BT_Disallow AMPDU\n"));
 					pHTInfo->bAcceptAddbaReq = FALSE;
 					if (GetTs(Adapter, (PTS_COMMON_INFO *)(&pRxTs), pMgntInfo->Bssid, 0, RX_DIR, FALSE))
 						TsInitDelBA(Adapter, (PTS_COMMON_INFO)pRxTs, RX_DIR);
@@ -61,7 +61,7 @@ void rtl8821ae_dm_bt_reject_ap_aggregated_packet(struct ieee80211_hw *hw, bool b
 		} else {
 			if (rtlpriv->mac80211.vendor == PEER_CISCO) {
 				if (!pHTInfo->bAcceptAddbaReq) {
-					RTPRINT(FBT, BT_TRACE, ("BT_Allow AMPDU \n"));
+					RTPRINT(FBT, BT_TRACE, ("BT_Allow AMPDU\n"));
 					pHTInfo->bAcceptAddbaReq = TRUE;
 				}
 			}
-- 
2.1.0

