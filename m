Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaGKQSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:18:35 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:54543 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaGKQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:18:33 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dmaengine: Remove unused definition of DMA_MAX_COOKIE
Date: Fri, 11 Jul 2014 18:18:26 +0200
Message-Id: <1405095506-14865-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit commit f04cd40701deace2efb9edd7120e59366bda2118 ("fsldma: fix
controller lockups"), its last (and only ever) user is gone.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 include/linux/dmaengine.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3d1c2aa51530..16e829034ae9 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -37,7 +37,6 @@
  */
 typedef s32 dma_cookie_t;
 #define DMA_MIN_COOKIE	1
-#define DMA_MAX_COOKIE	INT_MAX
 
 static inline int dma_submit_error(dma_cookie_t cookie)
 {
-- 
1.9.1

