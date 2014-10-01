Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaJARZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:25:46 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46827 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaJARZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:25:45 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@kernel.org,
        vegardno@ifi.uio.no
Subject: [PATCH] mm: Space required for open parenthesis
Date: Wed,  1 Oct 2014 18:25:39 +0100
Message-Id: <1412184339-3987-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: space required before the open parenthesis '('

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/kmemcheck.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
index fd814fd..89a7440 100644
--- a/mm/kmemcheck.c
+++ b/mm/kmemcheck.c
@@ -24,7 +24,7 @@ void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
 		return;
 	}
 
-	for(i = 0; i < pages; ++i)
+	for (i = 0; i < pages; ++i)
 		page[i].shadow = page_address(&shadow[i]);
 
 	/*
@@ -50,7 +50,7 @@ void kmemcheck_free_shadow(struct page *page, int order)
 
 	shadow = virt_to_page(page[0].shadow);
 
-	for(i = 0; i < pages; ++i)
+	for (i = 0; i < pages; ++i)
 		page[i].shadow = NULL;
 
 	__free_pages(shadow, order);
-- 
1.9.1

