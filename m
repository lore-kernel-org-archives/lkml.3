Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab3EORLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:11:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41417 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab3EORKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:10:54 -0400
From: Zhouping Liu <sanweidaying@gmail.com>
To: linux-mm@kvack.org
Cc: Zhouping Liu <zliu@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm, slab: corrected the comment 'kmem_cache_alloc' to 'slab_alloc_node'
Date: Thu, 16 May 2013 01:10:11 +0800
Message-Id: <1368637812-7329-1-git-send-email-sanweidaying@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhouping Liu <zliu@redhat.com>

commit 48356303ff(mm, slab: Rename __cache_alloc() -> slab_alloc())
forgot to update the comment 'kmem_cache_alloc' to 'slab_alloc_node'.

Signed-off-by: Zhouping Liu <zliu@redhat.com>
---
 mm/slab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 8ccd296..8efb5f7 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3339,7 +3339,7 @@ done:
 }
 
 /**
- * kmem_cache_alloc_node - Allocate an object on the specified node
+ * slab_alloc_node - Allocate an object on the specified node
  * @cachep: The cache to allocate from.
  * @flags: See kmalloc().
  * @nodeid: node number of the target node.
-- 
1.7.11.7

