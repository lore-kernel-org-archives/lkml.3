Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbaDPM3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:29:03 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45603 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDPM27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:28:59 -0400
From: Hiroshige Sato <sato.vintage@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Hiroshige Sato <sato.vintage@gmail.com>
Subject: [PATCH] [trivial] mm: Fix printk typo in dmapool.c
Date: Wed, 16 Apr 2014 21:28:34 +0900
Message-Id: <1397651314-4234-1-git-send-email-sato.vintage@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix printk typo in dmapool.c

Signed-off-by: Hiroshige Sato <sato.vintage@gmail.com>
---
 mm/dmapool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index c69781e..8058fcd 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -341,10 +341,10 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 				continue;
 			if (pool->dev)
 				dev_err(pool->dev,
-					"dma_pool_alloc %s, %p (corruped)\n",
+					"dma_pool_alloc %s, %p (corrupted)\n",
 					pool->name, retval);
 			else
-				pr_err("dma_pool_alloc %s, %p (corruped)\n",
+				pr_err("dma_pool_alloc %s, %p (corrupted)\n",
 					pool->name, retval);
 
 			/*
-- 
1.9.0

