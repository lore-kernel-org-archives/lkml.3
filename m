Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355Ab3JPRWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:22:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:32753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761068Ab3JPRWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851026"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 07/28] dmaengine: dmatest: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:25 +0530
Message-Id: <1381940926-25564-8-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/dmatest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 92f796c..59e287f 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -740,7 +740,7 @@ static int dmatest_func(void *data)
 					  len, 0);
 			failed_tests++;
 			continue;
-		} else if (status != DMA_SUCCESS) {
+		} else if (status != DMA_COMPLETE) {
 			enum dmatest_error_type type = (status == DMA_ERROR) ?
 				DMATEST_ET_DMA_ERROR : DMATEST_ET_DMA_IN_PROGRESS;
 			thread_result_add(info, result, type,
-- 
1.7.0.4

