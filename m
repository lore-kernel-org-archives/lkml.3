Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaHDAUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:20:47 -0400
Received: from s87.loopia.se ([194.9.94.112]:35680 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaHDAUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:20:42 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: jejb@parisc-linux.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 13/19] drivers: parisc: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:20:30 -0700
Message-Id: <1407111630-15087-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/parisc/dino.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 9eae983..a0580af 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -913,7 +913,7 @@ static int __init dino_probe(struct parisc_device *dev)
 	printk("%s version %s found at 0x%lx\n", name, version, hpa);
 
 	if (!request_mem_region(hpa, PAGE_SIZE, name)) {
-		printk(KERN_ERR "DINO: Hey! Someone took my MMIO space (0x%ld)!\n",
+		printk(KERN_ERR "DINO: Hey! Someone took my MMIO space (0x%lx)!\n",
 			hpa);
 		return 1;
 	}
-- 
2.0.0.526.g5318336

