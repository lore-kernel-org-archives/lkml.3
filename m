Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaGBLan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:30:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46290 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaGBL3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:29:50 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <lars@metafoo.de>,
        <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 2/4] dma: edma: Declare DMA_SLAVE_BUSWIDTH_3_BYTES as supported buswidth
Date: Wed, 2 Jul 2014 14:29:28 +0300
Message-ID: <1404300570-14082-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404300570-14082-1-git-send-email-peter.ujfalusi@ti.com>
References: <1404300570-14082-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eDMA can be configured for 3bytes word size for source and destination.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index d08c4dedef35..b512caf46944 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -982,6 +982,7 @@ static void __init edma_chan_init(struct edma_cc *ecc,
 
 #define EDMA_DMA_BUSWIDTHS	(BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) | \
 				 BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) | \
+				 BIT(DMA_SLAVE_BUSWIDTH_3_BYTES) | \
 				 BIT(DMA_SLAVE_BUSWIDTH_4_BYTES))
 
 static int edma_dma_device_slave_caps(struct dma_chan *dchan,
-- 
2.0.0

