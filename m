Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab3IREEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 00:04:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35274 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751586Ab3IREEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 00:04:54 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [TRIVIAL] treewide: fix "usefull" typo
Date: Wed, 18 Sep 2013 06:04:48 +0200
Message-Id: <1379477088-5283-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/base/dma-contiguous.c        | 2 +-
 drivers/net/wireless/ath/ath5k/dma.c | 2 +-
 sound/soc/codecs/alc5632.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 99802d6f..165c2c2 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -49,7 +49,7 @@ struct cma *dma_contiguous_default_area;
 
 /*
  * Default global CMA area size can be defined in kernel's .config.
- * This is usefull mainly for distro maintainers to create a kernel
+ * This is useful mainly for distro maintainers to create a kernel
  * that works correctly for most supported systems.
  * The size can be set in bytes or as a percentage of the total memory
  * in the system.
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index ce86f15..ba200b2 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -661,7 +661,7 @@ ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 			ah->ah_txq_isr_txok_all |= AR5K_REG_MS(sisr1,
 						AR5K_SISR1_QCU_TXEOL);
 
-		/* Currently this is not much usefull since we treat
+		/* Currently this is not much useful since we treat
 		 * all queues the same way if we get a TXURN (update
 		 * tx trigger level) but we might need it later on*/
 		if (pisr & AR5K_ISR_TXURN)
diff --git a/sound/soc/codecs/alc5632.c b/sound/soc/codecs/alc5632.c
index f2e62e4..19e9f22 100644
--- a/sound/soc/codecs/alc5632.c
+++ b/sound/soc/codecs/alc5632.c
@@ -614,7 +614,7 @@ struct _pll_div {
 };
 
 /* Note : pll code from original alc5632 driver. Not sure of how good it is */
-/* usefull only for master mode */
+/* useful only for master mode */
 static const struct _pll_div codec_master_pll_div[] = {
 
 	{  2048000,  8192000,	0x0ea0},
-- 
1.8.1.2

