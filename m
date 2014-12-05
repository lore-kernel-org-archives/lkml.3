Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaLEPrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:47:24 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37536 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaLEPrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:47:23 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, roberta.dobrescu@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging: rtl8723au: hal: Removed a space before semicolon
Date: Fri,  5 Dec 2014 21:17:02 +0530
Message-Id: <1417794422-6383-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning:

WARNING: space before semicolon prohibited

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index 6151e85..6878c91 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -9145,7 +9145,7 @@ u32 BTDM_BtTxRxCounterL(struct rtw_adapter *padapter)
 	u32	counters = 0;
 
 	counters = pHalData->bt_coexist.halCoex8723.lowPriorityTx+
-		pHalData->bt_coexist.halCoex8723.lowPriorityRx ;
+		pHalData->bt_coexist.halCoex8723.lowPriorityRx;
 	return counters;
 }
 
-- 
1.9.1

