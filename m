Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399Ab3JPRW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:22:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:5397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761371Ab3JPRWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851288"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        "Acked-by: Shawn Guo" <shawn.guo@linaro.org>
Subject: [PATCH 11/28] dmaengine: imx-sdma: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:29 +0530
Message-Id: <1381940926-25564-12-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/imx-sdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index fc43603..0e03b31 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -638,7 +638,7 @@ static void mxc_sdma_handle_channel_normal(struct sdma_channel *sdmac)
 	if (error)
 		sdmac->status = DMA_ERROR;
 	else
-		sdmac->status = DMA_SUCCESS;
+		sdmac->status = DMA_COMPLETE;
 
 	dma_cookie_complete(&sdmac->desc);
 	if (sdmac->desc.callback)
-- 
1.7.0.4

