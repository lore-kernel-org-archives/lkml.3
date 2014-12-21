Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaLURPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:15:39 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55755 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaLURPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:15:36 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] dma: imx-dma.c:  Remove unused function
Date: Sun, 21 Dec 2014 18:18:22 +0100
Message-Id: <1419182302-9672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function is_imx21_dma() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/dma/imx-dma.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 9d2c9e7..af1e643 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -230,11 +230,6 @@ static inline int is_imx1_dma(struct imxdma_engine *imxdma)
 	return imxdma->devtype == IMX1_DMA;
 }
 
-static inline int is_imx21_dma(struct imxdma_engine *imxdma)
-{
-	return imxdma->devtype == IMX21_DMA;
-}
-
 static inline int is_imx27_dma(struct imxdma_engine *imxdma)
 {
 	return imxdma->devtype == IMX27_DMA;
-- 
1.7.10.4

