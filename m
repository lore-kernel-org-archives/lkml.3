Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3KHMuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:50:15 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33780 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab3KHMuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:50:13 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 1/3] mm, slub: fix the typo in include/linux/slub_def.h
Date: Fri,  8 Nov 2013 20:47:36 +0800
Message-Id: <1383914858-14533-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110812-0320-0000-0000-000001AA0276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 include/linux/slub_def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index cc0b67e..f56bfa9 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -11,7 +11,7 @@
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
 	ALLOC_SLOWPATH,		/* Allocation by getting a new cpu slab */
-	FREE_FASTPATH,		/* Free to cpu slub */
+	FREE_FASTPATH,		/* Free to cpu slab */
 	FREE_SLOWPATH,		/* Freeing not to cpu slab */
 	FREE_FROZEN,		/* Freeing to frozen slab */
 	FREE_ADD_PARTIAL,	/* Freeing moves slab to partial list */
-- 
1.7.6.5

