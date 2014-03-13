Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaCMMLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:11:11 -0400
Received: from 17.mo4.mail-out.ovh.net ([46.105.41.16]:39889 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753652AbaCMMLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:11:09 -0400
X-Greylist: delayed 8740 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2014 08:11:09 EDT
From: mourn@2600fr.org
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        john.stultz@linaro.org, rebecca@android.com, mourn <mourn@2600fr.org>
Subject: [PATCH] staging: android: fix coding style
Date: Thu, 13 Mar 2014 10:44:55 +0100
Message-Id: <1394703895-9588-1-git-send-email-mourn@2600fr.org>
X-Mailer: git-send-email 1.7.10.4
X-Ovh-Tracer-Id: 9994613474855208728
X-Ovh-Remote: 82.120.247.142 (avelizy-152-1-44-142.w82-120.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mourn <mourn@2600fr.org>

Signed-off-by: mourn <mourn@2600fr.org>
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
1.7.10.4

