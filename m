Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3FGP2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:28:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:27453 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3FGP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:28:20 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine/trivial: at_hdmac: add curly brackets to if/else expressions
Date: Fri, 7 Jun 2013 17:28:18 +0200
Message-ID: <1370618898-18296-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct coding style following the patch:
7c407d3e54dcc0c79119553c8d5ef176c1d5bc3a (DMA: AT91:
Get residual bytes in dma buffer).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 50953a7..b321562 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -299,8 +299,9 @@ static int atc_get_bytes_left(struct dma_chan *chan)
 		if (atchan->remain_desc < 0) {
 			ret = -EINVAL;
 			goto out;
-		} else
+		} else {
 			ret = atchan->remain_desc;
+		}
 	} else {
 		/*
 		 * Get residual bytes when current
@@ -1120,8 +1121,9 @@ atc_tx_status(struct dma_chan *chan,
 	if (unlikely(bytes < 0)) {
 		dev_vdbg(chan2dev(chan), "get residual bytes error\n");
 		return DMA_ERROR;
-	} else
+	} else {
 		dma_set_residue(txstate, bytes);
+	}
 
 	dev_vdbg(chan2dev(chan), "tx_status %d: cookie = %d residue = %d\n",
 		 ret, cookie, bytes);
-- 
1.8.2.2

