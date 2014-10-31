Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbaJaGog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:44:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41804 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaJaGoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:44:34 -0400
From: Tristan Lelong <tristan@lelong.xyz>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        ccross@android.com, mitchelh@codeaurora.org,
        benjamin.gaignard@linaro.org, romlem@google.com,
        daeseok.youn@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tristan Lelong <tristan@lelong.xyz>
Subject: [PATCH] Staging: android: ion: fix typos in comments
Date: Thu, 30 Oct 2014 23:43:36 -0700
Message-Id: <1414737816-20118-1-git-send-email-tristan@lelong.xyz>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding style warnings detected by checkpatch.pl in ion.

Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
---
 drivers/staging/android/ion/ion.c      | 2 +-
 drivers/staging/android/ion/ion.h      | 2 +-
 drivers/staging/android/ion/ion_priv.h | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 290d4d2..8724ef8 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -250,7 +250,7 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	   our systems the only dma_address space is physical addresses.
 	   Additionally, we can't afford the overhead of invalidating every
 	   allocation via dma_map_sg. The implicit contract here is that
-	   memory comming from the heaps is ready for dma, ie if it has a
+	   memory coming from the heaps is ready for dma, ie if it has a
 	   cached mapping that mapping has been invalidated */
 	for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents, i)
 		sg_dma_address(sg) = sg_phys(sg);
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index d305bb7..443db84 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -76,7 +76,7 @@ struct ion_platform_data {
  *		size
  *
  * Calls memblock reserve to set aside memory for heaps that are
- * located at specific memory addresses or of specfic sizes not
+ * located at specific memory addresses or of specific sizes not
  * managed by the kernel
  */
 void ion_reserve(struct ion_platform_data *data);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index c8f0175..18a5f93 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -345,7 +345,7 @@ void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
  * functions for creating and destroying a heap pool -- allows you
  * to keep a pool of pre allocated memory to use from your heap.  Keeping
  * a pool of memory that is ready for dma, ie any cached mapping have been
- * invalidated from the cache, provides a significant peformance benefit on
+ * invalidated from the cache, provides a significant performance benefit on
  * many systems */
 
 /**
@@ -362,7 +362,7 @@ void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
  *
  * Allows you to keep a pool of pre allocated pages to use from your heap.
  * Keeping a pool of pages that is ready for dma, ie any cached mapping have
- * been invalidated from the cache, provides a significant peformance benefit
+ * been invalidated from the cache, provides a significant performance benefit
  * on many systems
  */
 struct ion_page_pool {
-- 
2.1.1

