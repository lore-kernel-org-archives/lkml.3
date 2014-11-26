Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaKZL07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:26:59 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33247 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaKZL05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:26:57 -0500
From: Athira Lekshmi C V <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: hsweeten@visionengravers.com, abbotti@mev.co.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi C V <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:comedi:drivers: Fixed checkpatch warning
Date: Wed, 26 Nov 2014 16:56:55 +0530
Message-Id: <1417001215-30338-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning:
WARNING: please, no space before tabs

Signed-off-by: Athira Lekshmi C V <andnlnbn18@gmail.com>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 69e543a..bff4852 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -108,7 +108,7 @@ TRIG_WAKE_EOS
 #define   IRQ_LVL_BITS(x)		(((x) & 0xf) << 4)	/*  sets irq level */
 #define   FIFO_INTR_EN_BIT		0x100	/*  enable fifo interrupts */
 #define   FIFO_INTR_FHF_BIT		0x200	/*  interrupt fifo half full */
-#define   DMA_INTR_EN_BIT 		0x800	/*  enable interrupt on dma terminal count */
+#define   DMA_INTR_EN_BIT		0x800	/*  enable interrupt on dma terminal count */
 #define   DMA_DEM_EN_BIT	0x1000	/*  enables demand mode dma */
 #define I8253_BASE_REG		0x14
 #define I8253_MODE_REG		0x17
-- 
1.7.9.5

