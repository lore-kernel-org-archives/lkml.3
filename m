Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbaEVEjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:39:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39837 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaEVEjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:39:24 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: rientjes@google.com, m.szyprowski@samsung.com, mina86@mina86.com,
        linux-kernel@vger.kernel.org
Cc: gunho.lee@lge.com, gurugio@gmail.com, Gioh Kim <gioh.kim@lge.com>
Subject: [PATCH] drivers/base/dma-contiguous.c: erratum of dev_get_cma_area
Date: Thu, 22 May 2014 13:31:37 +0900
Message-Id: <1400733097-1176-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix erratum get_dev_cma_area into dev_get_cma_area

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/base/dma-contiguous.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index b056661..6343f25 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -291,7 +291,7 @@ err:
  *
  * This function allocates memory buffer for specified device. It uses
  * device specific contiguous memory area if available or the default
- * global one. Requires architecture specific get_dev_cma_area() helper
+ * global one. Requires architecture specific dev_get_cma_area() helper
  * function.
  */
 struct page *dma_alloc_from_contiguous(struct device *dev, int count,
-- 
1.7.9.5

