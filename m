Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaIBAa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:30:57 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36464 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaIBAay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:30:54 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 09/12] Staging: rtl8821ae: hal_bt_coexist: fix coding style issue
Date: Mon,  1 Sep 2014 20:29:33 -0400
Message-Id: <1409617776-30730-9-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue where the else conditional statement should
follow the closing curly brace '}'.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index f1cf373..869b094 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -251,8 +251,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state(struct ieee80211_hw *hw,
 					("[DM][BT], RSSI state stay at High\n"));
 			}
 		}
-	}
-	else if (level_num == 3) {
+	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
 			RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 				("[DM][BT], RSSI thresh error!!\n"));
-- 
2.1.0

