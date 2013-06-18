Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3FRC0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:26:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3FRC0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:26:39 -0400
Date: Mon, 17 Jun 2013 22:26:28 -0400
Message-Id: <201306180226.r5I2QSxf010793@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/7] radeon: Remove redundant __list_for_each definition from mkregtable.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>
---
 drivers/gpu/drm/radeon/mkregtable.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/mkregtable.c b/drivers/gpu/drm/radeon/mkregtable.c
index 5a82b6b..af85299 100644
--- a/drivers/gpu/drm/radeon/mkregtable.c
+++ b/drivers/gpu/drm/radeon/mkregtable.c
@@ -373,19 +373,6 @@ static inline void list_splice_tail_init(struct list_head *list,
 		pos = pos->next)
 
 /**
- * __list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This variant differs from list_for_each() in that it's the
- * simplest possible list iteration code, no prefetching is done.
- * Use this for code that knows the list to be very short (empty
- * or 1 entry) most of the time.
- */
-#define __list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
-
-/**
  * list_for_each_prev	-	iterate over a list backwards
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.
-- 
1.8.1.4

