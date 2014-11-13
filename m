Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaKMDIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 22:08:52 -0500
Received: from relay.variantweb.net ([104.131.199.242]:53830 "EHLO
	relay.variantweb.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753850AbaKMDIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 22:08:50 -0500
From: Seth Jennings <sjennings@variantweb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjennings@variantweb.net>, trivial@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] zbud, zswap: change module author email
Date: Wed, 12 Nov 2014 21:08:46 -0600
Message-Id: <1415848126-9775-1-git-send-email-sjennings@variantweb.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old email no longer viable.

Signed-off-by: Seth Jennings <sjennings@variantweb.net>
---
 mm/zbud.c  | 2 +-
 mm/zswap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index db8de74..4e387be 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -619,5 +619,5 @@ module_init(init_zbud);
 module_exit(exit_zbud);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Seth Jennings <sjenning@linux.vnet.ibm.com>");
+MODULE_AUTHOR("Seth Jennings <sjennings@variantweb.net>");
 MODULE_DESCRIPTION("Buddy Allocator for Compressed Pages");
diff --git a/mm/zswap.c b/mm/zswap.c
index ea064c1..c154306 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -951,5 +951,5 @@ error:
 late_initcall(init_zswap);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Seth Jennings <sjenning@linux.vnet.ibm.com>");
+MODULE_AUTHOR("Seth Jennings <sjennings@variantweb.net>");
 MODULE_DESCRIPTION("Compressed cache for swap pages");
-- 
1.9.3

