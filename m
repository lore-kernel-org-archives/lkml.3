Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaBLL06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:26:58 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:45983 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaBLL05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:26:57 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-mtd@lists.infradead.org>,
        Josh Wu <josh.wu@atmel.com>
CC: <computersforpeace@gmail.com>, <dedekind1@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MTD: atmel_nand: POI fall back is not an issue: change log level
Date: Wed, 12 Feb 2014 12:26:54 +0100
Message-ID: <1392204414-20700-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mtd/nand/atmel_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index c36e9b84487c..8d210f8a072d 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -430,7 +430,7 @@ err_dma:
 	dma_unmap_single(dma_dev->dev, phys_addr, len, dir);
 err_buf:
 	if (err != 0)
-		dev_warn(host->dev, "Fall back to CPU I/O\n");
+		dev_dbg(host->dev, "Fall back to CPU I/O\n");
 	return err;
 }
 
-- 
1.8.2.2

