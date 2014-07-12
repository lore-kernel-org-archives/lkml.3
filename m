Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaGLVTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 17:19:55 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:40590 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaGLVTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 17:19:51 -0400
From: Modestas Stankus <stankus.modestas@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Modestas Stankus <stankus.modestas@gmail.com>, john.stultz@linaro.org,
        ccross@android.com, rebecca@android.com, lauraa@codeaurora.org,
        benjamin.gaignard@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: Coding style fix
Date: Sun, 13 Jul 2014 00:18:46 +0300
Message-Id: <1405199926-24206-1-git-send-email-stankus.modestas@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes warnings of checkpatch.pl script:
WARNING: void function return statements are not generally useful
+       return;
+}

Task of Eudyptula challenge.
---
 drivers/staging/android/ion/ion_carveout_heap.c | 1 -
 1 file changed, 1 deletion(-)

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
-- 
2.0.1

