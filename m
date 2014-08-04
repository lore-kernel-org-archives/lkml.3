Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaHDAUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:20:52 -0400
Received: from s87.loopia.se ([194.9.94.112]:35720 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbaHDAUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:20:50 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: JBottomley@parallels.com, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 14/19] hpsa: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:20:40 -0700
Message-Id: <1407111640-15124-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6b35d0d..47358b5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6088,7 +6088,7 @@ static void print_cfg_table(struct device *dev, struct CfgTable *tb)
 	       readl(&(tb->HostWrite.CoalIntDelay)));
 	dev_info(dev, "   Coalesce Interrupt Count = 0x%x\n",
 	       readl(&(tb->HostWrite.CoalIntCount)));
-	dev_info(dev, "   Max outstanding commands = 0x%d\n",
+	dev_info(dev, "   Max outstanding commands = 0x%x\n",
 	       readl(&(tb->CmdsOutMax)));
 	dev_info(dev, "   Bus Types = 0x%x\n", readl(&(tb->BusTypes)));
 	for (i = 0; i < 16; i++)
-- 
2.0.0.526.g5318336

