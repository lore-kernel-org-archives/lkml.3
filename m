Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaHMNKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:10:08 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43447 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaHMNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:10:04 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ccross@android.com, swetland@google.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, joe@perches.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org, Phong Tran <tranmanphong@gmail.com>
Subject: [Patch V2 3/3] staging: android: ion: Fix coding style
Date: Wed, 13 Aug 2014 20:09:40 +0700
Message-Id: <1407935380-9324-3-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407935380-9324-1-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
 <1407935380-9324-1-git-send-email-tranmanphong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix checkpatch.pl warning
- Remove the return of void function
Tested by compilation.

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/staging/android/ion/ion.c               | 1 -
 drivers/staging/android/ion/ion_carveout_heap.c | 1 -
 drivers/staging/android/ion/ion_chunk_heap.c    | 1 -
 drivers/staging/android/ion/ion_dummy_driver.c  | 2 --
 drivers/staging/android/ion/ion_system_heap.c   | 1 -
 5 files changed, 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index cad76ae..56604f4 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1057,7 +1057,6 @@ static void *ion_dma_buf_kmap(struct dma_buf *dmabuf, unsigned long offset)
 static void ion_dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long offset,
 			       void *ptr)
 {
-	return;
 }
 
 static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start,
diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index dcb6f21..9156d82 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -133,7 +133,6 @@ static struct sg_table *ion_carveout_heap_map_dma(struct ion_heap *heap,
 static void ion_carveout_heap_unmap_dma(struct ion_heap *heap,
 					struct ion_buffer *buffer)
 {
-	return;
 }
 
 static struct ion_heap_ops carveout_heap_ops = {
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 9c3e49a..3e6ec2e 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -126,7 +126,6 @@ static struct sg_table *ion_chunk_heap_map_dma(struct ion_heap *heap,
 static void ion_chunk_heap_unmap_dma(struct ion_heap *heap,
 				     struct ion_buffer *buffer)
 {
-	return;
 }
 
 static struct ion_heap_ops chunk_heap_ops = {
diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 6d0a38a..f3ea1c3 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -152,7 +152,5 @@ static void __exit ion_dummy_exit(void)
 				dummy_heaps[ION_HEAP_TYPE_CHUNK].size);
 		chunk_ptr = NULL;
 	}
-
-	return;
 }
 __exitcall(ion_dummy_exit);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 6b77c51..da2a63c 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -205,7 +205,6 @@ static struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
 static void ion_system_heap_unmap_dma(struct ion_heap *heap,
 				      struct ion_buffer *buffer)
 {
-	return;
 }
 
 static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
-- 
1.9.3

