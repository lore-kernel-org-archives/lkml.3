Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab3CGNfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:35:20 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47564 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3CGNfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:35:18 -0500
Message-ID: <1362663307.13839.1.camel@phoenix>
Subject: [PATCH] dmaengine: mmp_pdma: Remove duplicate code to set DMA_SLAVE
 capability
From: Axel Lin <axel.lin@ingics.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: Zhangfei Gao <zhangfei.gao@marvell.com>, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 21:35:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/dma/mmp_pdma.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index c26699f..3d0f51b 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -825,7 +825,6 @@ static int mmp_pdma_probe(struct platform_device *op)
 
 	dma_cap_set(DMA_SLAVE, pdev->device.cap_mask);
 	dma_cap_set(DMA_MEMCPY, pdev->device.cap_mask);
-	dma_cap_set(DMA_SLAVE, pdev->device.cap_mask);
 	pdev->device.dev = &op->dev;
 	pdev->device.device_alloc_chan_resources = mmp_pdma_alloc_chan_resources;
 	pdev->device.device_free_chan_resources = mmp_pdma_free_chan_resources;
-- 
1.7.9.5



