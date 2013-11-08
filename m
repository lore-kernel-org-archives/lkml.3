Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3KHM6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:58:54 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44034 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab3KHM6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:58:53 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 2/3] mm, slub: fix the typo in mm/slub.c
Date: Fri,  8 Nov 2013 20:47:37 +0800
Message-Id: <1383914858-14533-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1383914858-14533-1-git-send-email-zwu.kernel@gmail.com>
References: <1383914858-14533-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110812-7182-0000-0000-0000090BD0FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 mm/slub.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c3eb3d3..7a64327 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -155,7 +155,7 @@ static inline bool kmem_cache_has_cpu_partial(struct kmem_cache *s)
 /*
  * Maximum number of desirable partial slabs.
  * The existence of more partial slabs makes kmem_cache_shrink
- * sort the partial list by the number of objects in the.
+ * sort the partial list by the number of objects in use.
  */
 #define MAX_PARTIAL 10
 
@@ -2829,8 +2829,8 @@ static struct kmem_cache *kmem_cache_node;
  * slab on the node for this slabcache. There are no concurrent accesses
  * possible.
  *
- * Note that this function only works on the kmalloc_node_cache
- * when allocating for the kmalloc_node_cache. This is used for bootstrapping
+ * Note that this function only works on the kmem_cache_node
+ * when allocating for the kmem_cache_node. This is used for bootstrapping
  * memory on a fresh node that has no slab structures yet.
  */
 static void early_kmem_cache_node_alloc(int node)
-- 
1.7.6.5

