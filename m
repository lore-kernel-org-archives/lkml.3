Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaHDATH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:19:07 -0400
Received: from s87.loopia.se ([194.9.94.112]:29873 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaHDATD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:19:03 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: mike.miller@hp.com, iss_storagedev@hp.com, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 04/19] drivers: cciss: fix %d confusingly prefixed with 0x in format strings
Date: Sun,  3 Aug 2014 17:18:50 -0700
Message-Id: <1407111530-14624-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/block/cciss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ff20f19..99f778d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3838,7 +3838,7 @@ static void print_cfg_table(ctlr_info_t *h)
 	       readl(&(tb->HostWrite.CoalIntDelay)));
 	dev_dbg(&h->pdev->dev, "   Coalesce Interrupt Count = 0x%x\n",
 	       readl(&(tb->HostWrite.CoalIntCount)));
-	dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%d\n",
+	dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%x\n",
 	       readl(&(tb->CmdsOutMax)));
 	dev_dbg(&h->pdev->dev, "   Bus Types = 0x%x\n",
 		readl(&(tb->BusTypes)));
-- 
2.0.0.526.g5318336

