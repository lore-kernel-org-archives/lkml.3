Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3EQPqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:46:33 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37787 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3EQPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:46:29 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v7, part3 08/16] mm: fix some trivial typos in comments
Date: Fri, 17 May 2013 23:45:10 +0800
Message-Id: <1368805518-2634-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368805518-2634-1-git-send-email-jiang.liu@huawei.com>
References: <1368805518-2634-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some trivial typos in comments.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memory_hotplug.c | 2 +-
 mm/page_alloc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a221fac..037d41d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -309,7 +309,7 @@ static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 	/* can't move pfns which are higher than @z2 */
 	if (end_pfn > zone_end_pfn(z2))
 		goto out_fail;
-	/* the move out part mast at the left most of @z2 */
+	/* the move out part must be at the left most of @z2 */
 	if (start_pfn > z2->zone_start_pfn)
 		goto out_fail;
 	/* must included/overlap */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 13e566a..88c8642 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2865,7 +2865,7 @@ EXPORT_SYMBOL(free_pages_exact);
  * nr_free_zone_pages() counts the number of counts pages which are beyond the
  * high watermark within all zones at or below a given zone index.  For each
  * zone, the number of pages is calculated as:
- *     present_pages - high_pages
+ *     managed_pages - high_pages
  */
 static unsigned long nr_free_zone_pages(int offset)
 {
-- 
1.8.1.2

