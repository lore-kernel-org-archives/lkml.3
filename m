Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161804AbaDPPkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:40:06 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:65519 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319AbaDPPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:40:03 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, joe@perches.com, john.stultz@linaro.org,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] staging: android: uapi: fix coding style
Date: Thu, 17 Apr 2014 00:39:44 +0900
Message-Id: <1397662784-5687-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix checkpatch.pl warning and errors.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/android/uapi/ion.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/uapi/ion.h b/drivers/staging/android/uapi/ion.h
index f09e7c1..6aa4956 100644
--- a/drivers/staging/android/uapi/ion.h
+++ b/drivers/staging/android/uapi/ion.h
@@ -27,12 +27,12 @@ typedef int ion_user_handle_t;
  * @ION_HEAP_TYPE_SYSTEM:	 memory allocated via vmalloc
  * @ION_HEAP_TYPE_SYSTEM_CONTIG: memory allocated via kmalloc
  * @ION_HEAP_TYPE_CARVEOUT:	 memory allocated from a prereserved
- * 				 carveout heap, allocations are physically
- * 				 contiguous
+ *				 carveout heap, allocations are physically
+ *				 contiguous
  * @ION_HEAP_TYPE_DMA:		 memory allocated via DMA API
  * @ION_NUM_HEAPS:		 helper for iterating over heaps, a bit mask
- * 				 is used to identify the heaps, so only 32
- * 				 total heap types are supported
+ *				 is used to identify the heaps, so only 32
+ *				 total heap types are supported
  */
 enum ion_heap_type {
 	ION_HEAP_TYPE_SYSTEM,
@@ -50,7 +50,7 @@ enum ion_heap_type {
 #define ION_HEAP_CARVEOUT_MASK		(1 << ION_HEAP_TYPE_CARVEOUT)
 #define ION_HEAP_TYPE_DMA_MASK		(1 << ION_HEAP_TYPE_DMA)
 
-#define ION_NUM_HEAP_IDS		sizeof(unsigned int) * 8
+#define ION_NUM_HEAP_IDS		(sizeof(unsigned int) * 8)
 
 /**
  * allocation flags - the lower 16 bits are used by core ion, the upper 16
@@ -78,7 +78,7 @@ enum ion_heap_type {
  * @align:		required alignment of the allocation
  * @heap_id_mask:	mask of heap ids to allocate from
  * @flags:		flags passed to heap
- * @handle:		pointer that will be populated with a cookie to use to 
+ * @handle:		pointer that will be populated with a cookie to use to
  *			refer to this allocation
  *
  * Provided by userspace as an argument to the ioctl
-- 
1.7.9.5

