Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaLJMzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:55:18 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:55286 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaLJMzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:55:16 -0500
Date: Wed, 10 Dec 2014 14:55:10 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net, asaf.vertz@tandemg.com, arnd@arndb.de,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ux500: fix checkpatch errors
Message-ID: <20141210125510.GA1904@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style error, code indent should use tabs where possible 

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 92105f3..b189e1d 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -479,13 +479,13 @@ static void cryp_dma_setup_channel(struct cryp_device_data *device_data,
 		.dst_addr = device_data->phybase + CRYP_DMA_TX_FIFO,
 		.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
 		.dst_maxburst = 4,
-        };
+	};
 	struct dma_slave_config cryp2mem = {
 		.direction = DMA_DEV_TO_MEM,
 		.src_addr = device_data->phybase + CRYP_DMA_RX_FIFO,
 		.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
 		.src_maxburst = 4,
-        };
+	};
 
 	dma_cap_zero(device_data->dma.mask);
 	dma_cap_set(DMA_SLAVE, device_data->dma.mask);
@@ -1772,8 +1772,8 @@ static int ux500_cryp_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(ux500_cryp_pm, ux500_cryp_suspend, ux500_cryp_resume);
 
 static const struct of_device_id ux500_cryp_match[] = {
-        { .compatible = "stericsson,ux500-cryp" },
-        { },
+	{ .compatible = "stericsson,ux500-cryp" },
+	{ },
 };
 
 static struct platform_driver cryp_driver = {
-- 
1.7.0.4

