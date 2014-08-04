Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaHDAVC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:21:02 -0400
Received: from s87.loopia.se ([194.9.94.112]:35755 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbaHDAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:21:00 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 15/19] staging: nokia_h4p: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:20:49 -0700
Message-Id: <1407111649-15159-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/staging/nokia_h4p/nokia_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 775e1d0..240da0c 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -1113,7 +1113,7 @@ static int hci_h4p_probe(struct platform_device *pdev)
 				    GPIOF_OUT_INIT_LOW, "bt_wakeup");
 
 	if (err < 0) {
-		dev_err(info->dev, "Cannot get GPIO line 0x%d",
+		dev_err(info->dev, "Cannot get GPIO line 0x%x",
 			info->bt_wakeup_gpio);
 		return err;
 	}
-- 
2.0.0.526.g5318336

