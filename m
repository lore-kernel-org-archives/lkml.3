Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaICBA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:00:58 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50832 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaICBA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:00:57 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 1/5] Staging: rtl8821ae: hal_bt_coexist: fix commenting style
Date: Tue,  2 Sep 2014 21:00:42 -0400
Message-Id: <1409706046-23616-1-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix commenting style from C99 comments to C89 comments

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index 8bee772..cff300c 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -44,7 +44,7 @@ void rtl8821ae_dm_bt_reject_ap_aggregated_packet(struct ieee80211_hw *hw, bool b
 	PRX_TS_RECORD			pRxTs = NULL;
 
 	if(b_reject){
-		// Do not allow receiving A-MPDU aggregation.
+		/* Do not allow receiving A-MPDU aggregation. */
 		if (rtlpriv->mac80211.vendor == PEER_CISCO) {
 				if (pHTInfo->bAcceptAddbaReq) {
 					RTPRINT(FBT, BT_TRACE, ("BT_Disallow AMPDU \n"));
-- 
2.1.0

