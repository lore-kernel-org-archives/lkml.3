Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaHLQSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:18:41 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43037 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaHLQSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:18:38 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, ccross@android.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 3/5] staging: android: ion: ion_system_heap.c Fix checkpatch warning
Date: Tue, 12 Aug 2014 23:17:28 +0700
Message-Id: <1407860250-9779-4-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix coding rule

- Remove return of void function

Tested by compilation

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/staging/android/ion/ion_system_heap.c | 1 -
 1 file changed, 1 deletion(-)

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

