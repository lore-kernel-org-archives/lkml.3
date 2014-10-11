Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaJKQVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:21:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:29315 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaJKQVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:21:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,699,1406617200"; 
   d="scan'208";a="603887878"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 6/6] dmaengine: remove FSLDMA_EXTERNAL_START
Date: Sat, 11 Oct 2014 21:16:48 +0530
Message-Id: <1413042408-28491-7-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
References: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as users have been converted, so no need of this custom method

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 include/linux/dmaengine.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index ce8a08e..3254a03 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -199,15 +199,12 @@ enum dma_ctrl_flags {
  * configuration data in statically from the platform). An additional
  * argument of struct dma_slave_config must be passed in with this
  * command.
- * @FSLDMA_EXTERNAL_START: this command will put the Freescale DMA controller
- * into external start mode.
  */
 enum dma_ctrl_cmd {
 	DMA_TERMINATE_ALL,
 	DMA_PAUSE,
 	DMA_RESUME,
 	DMA_SLAVE_CONFIG,
-	FSLDMA_EXTERNAL_START,
 };
 
 /**
-- 
1.7.0.4

