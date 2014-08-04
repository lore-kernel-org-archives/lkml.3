Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaHDAUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:20:00 -0400
Received: from s87.loopia.se ([194.9.94.112]:43303 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbaHDAT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:19:57 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 09/19] net: smc911x: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:19:46 -0700
Message-Id: <1407111586-14903-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/net/ethernet/smsc/smc911x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 1c44e67..9778cba 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -730,7 +730,7 @@ static void smc911x_phy_detect(struct net_device *dev)
 			lp->phy_type = id1 << 16 | id2;
 	}
 
-	DBG(SMC_DEBUG_MISC, dev, "phy_id1=0x%x, phy_id2=0x%x phyaddr=0x%d\n",
+	DBG(SMC_DEBUG_MISC, dev, "phy_id1=0x%x, phy_id2=0x%x phyaddr=0x%x\n",
 	    id1, id2, lp->mii.phy_id);
 }
 
-- 
2.0.0.526.g5318336

