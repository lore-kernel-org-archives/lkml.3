Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaIBAc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:32:59 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38371 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaIBAas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:48 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 05/12] Staging: rtl8821ae: hal_bt_coexist: fix pointer placement coding style issue
Date: Mon,  1 Sep 2014 20:29:29 -0400
Message-Id: <1409617776-30730-5-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
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
index 48c6160..a478ee4 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -49,7 +49,7 @@ void rtl8821ae_dm_bt_reject_ap_aggregated_packet(struct ieee80211_hw *hw, bool b
 				if (pHTInfo->bAcceptAddbaReq) {
 					RTPRINT(FBT, BT_TRACE, ("BT_Disallow AMPDU \n"));
 					pHTInfo->bAcceptAddbaReq = FALSE;
-					if (GetTs(Adapter, (PTS_COMMON_INFO*)(&pRxTs), pMgntInfo->Bssid, 0, RX_DIR, FALSE))
+					if (GetTs(Adapter, (PTS_COMMON_INFO *)(&pRxTs), pMgntInfo->Bssid, 0, RX_DIR, FALSE))
 						TsInitDelBA(Adapter, (PTS_COMMON_INFO)pRxTs, RX_DIR);
 				}
 			} else {
-- 
2.1.0

