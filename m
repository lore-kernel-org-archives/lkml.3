Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3KHMuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:50:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45833 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3KHMuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:50:14 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 3/3] mm, memory-failure: fix the typo in me_pagecache_dirty()
Date: Fri,  8 Nov 2013 20:47:38 +0800
Message-Id: <1383914858-14533-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1383914858-14533-1-git-send-email-zwu.kernel@gmail.com>
References: <1383914858-14533-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110812-0928-0000-0000-0000036C66B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 mm/memory-failure.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index bf3351b..d8ec181 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -611,7 +611,7 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 }
 
 /*
- * Dirty cache page page
+ * Dirty cache page
  * Issues: when the error hit a hole page the error is not properly
  * propagated.
  */
-- 
1.7.6.5

