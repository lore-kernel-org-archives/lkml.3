Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaHDAUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:20:21 -0400
Received: from s87.loopia.se ([194.9.94.112]:35567 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaHDAUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:20:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 11/19] iwl4965: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:20:05 -0700
Message-Id: <1407111605-15005-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c159c05..7d6fd59 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4633,7 +4633,7 @@ il4965_store_tx_power(struct device *d, struct device_attribute *attr,
 	else {
 		ret = il_set_tx_power(il, val, false);
 		if (ret)
-			IL_ERR("failed setting tx power (0x%d).\n", ret);
+			IL_ERR("failed setting tx power (0x%x).\n", ret);
 		else
 			ret = count;
 	}
-- 
2.0.0.526.g5318336

