Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbaITRni (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:43:38 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:33394 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936AbaITRng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:43:36 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: usdhi6rol0: Remove unnecessary header files
Date: Sat, 20 Sep 2014 23:13:14 +0530
Message-Id: <1411234994-25520-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These headers are not required hence this change removes them from
the driver.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/usdhi6rol0.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
index f0a39eb..4094d8f 100644
--- a/drivers/mmc/host/usdhi6rol0.c
+++ b/drivers/mmc/host/usdhi6rol0.c
@@ -12,21 +12,14 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
-#include <linux/highmem.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/log2.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
-#include <linux/mmc/sd.h>
 #include <linux/mmc/sdio.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/platform_device.h>
-#include <linux/scatterlist.h>
-#include <linux/string.h>
-#include <linux/time.h>
-#include <linux/virtio.h>
 #include <linux/workqueue.h>
 
 #define USDHI6_SD_CMD		0x0000
-- 
1.8.3.2

