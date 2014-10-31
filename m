Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbaJaKf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:35:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:32622 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240AbaJaKf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:35:58 -0400
From: w00218164 <weiyuan.wei@huawei.com>
To: <akpm@linux-foundation.org>, <mgorman@suse.de>, <rientjes@google.com>,
        <hannes@cmpxchg.org>, <riel@redhat.com>, <vbabka@suse.cz>,
        <sasha.levin@oracle.com>
CC: <lizefan@huawei.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Fix a spelling mistake
Date: Fri, 31 Oct 2014 18:37:53 +0800
Message-ID: <1414751873-19981-1-git-send-email-weiyuan.wei@huawei.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.243]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yuan <weiyuan.wei@huawei.com>

This patch fixes a spelling mistake in func
__zone_watermark_ok, which may was wrongly spelled my.

Signed-off-by Wei Yuan <weiyuan.wei@huawei.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9cd36b8..f3ce2e1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1714,7 +1714,7 @@ static bool __zone_watermark_ok(struct zone *z, unsigned int order,
 			unsigned long mark, int classzone_idx, int alloc_flags,
 			long free_pages)
 {
-	/* free_pages my go negative - that's OK */
+	/* free_pages may go negative - that's OK */
 	long min = mark;
 	int o;
 	long free_cma = 0;
-- 
2.1.0

