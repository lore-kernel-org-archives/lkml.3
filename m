Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaICBBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:01:43 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:59731 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbaICBBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:01:00 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 3/5] Staging: rtl8821ae: hal_bt_coexist: fix pointer placement coding style issue
Date: Tue,  2 Sep 2014 21:00:44 -0400
Message-Id: <1409706046-23616-3-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409706046-23616-1-git-send-email-zero579911@gmail.com>
References: <1409706046-23616-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix pointer placement coding style issue, where using "foo *" is
preferable over "foo*".

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index 40d521e..13cc5ba 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -49,7 +49,7 @@ void rtl8821ae_dm_bt_reject_ap_aggregated_packet(struct ieee80211_hw *hw, bool b
 				if (pHTInfo->bAcceptAddbaReq) {
 					RTPRINT(FBT, BT_TRACE, ("BT_Disallow AMPDU\n"));
 					pHTInfo->bAcceptAddbaReq = FALSE;
-					if (GetTs(Adapter, (PTS_COMMON_INFO*)(&pRxTs), pMgntInfo->Bssid, 0, RX_DIR, FALSE))
+					if (GetTs(Adapter, (PTS_COMMON_INFO *)(&pRxTs), pMgntInfo->Bssid, 0, RX_DIR, FALSE))
 						TsInitDelBA(Adapter, (PTS_COMMON_INFO)pRxTs, RX_DIR);
 				}
 			} else {
-- 
2.1.0

