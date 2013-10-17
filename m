Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229Ab3JQDJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:09:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:28485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762120Ab3JQDJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,511,1378882800"; 
   d="scan'208";a="394167445"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 29/29] dmaengine: remove unused DMA_SUCCESS
Date: Thu, 17 Oct 2013 07:46:02 +0530
Message-Id: <1381976162-14617-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-29-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-29-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after all the users are converted

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 include/linux/dmaengine.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 683c380..4b460a6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -55,7 +55,6 @@ enum dma_status {
 	DMA_IN_PROGRESS,
 	DMA_PAUSED,
 	DMA_ERROR,
-	DMA_SUCCESS,
 };
 
 /**
-- 
1.7.0.4

