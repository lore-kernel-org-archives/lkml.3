Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaHLQTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:19:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38549 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaHLQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:18:41 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, ccross@android.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 4/5] staging: android: ion: ion_carveout_heap.c Fix checkpatch warning
Date: Tue, 12 Aug 2014 23:17:29 +0700
Message-Id: <1407860250-9779-5-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix coding style

- Remove return of void function

Tested by compilation

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
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
1.9.3

