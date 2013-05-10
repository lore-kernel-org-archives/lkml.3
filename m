Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3EJNTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:19:19 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:1853 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3EJNTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:19:18 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Vinod Koul <vinod.koul@intel.com>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3] dmaengine: at_hdmac/trivial: correct typo in comment
Date: Fri, 10 May 2013 15:19:13 +0200
Message-ID: <042cac60509755c1340d141315a9a8eb1965438a.1368191734.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index e923cda..cd49420 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1120,7 +1120,7 @@ static int atc_alloc_chan_resources(struct dma_chan *chan)
 		 */
 		BUG_ON(!atslave->dma_dev || atslave->dma_dev != atdma->dma_common.dev);
 
-		/* if cfg configuration specified take it instad of default */
+		/* if cfg configuration specified take it instead of default */
 		if (atslave->cfg)
 			cfg = atslave->cfg;
 	}
-- 
1.8.0

