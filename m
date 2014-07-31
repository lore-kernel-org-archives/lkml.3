Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaGaLuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:50:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaGaLuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:50:07 -0400
From: "Jerome Marchand" <jmarchan@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/2] mm, vmscan: fix an outdated comment still mentioning get_scan_ratio
Date: Thu, 31 Jul 2014 13:49:44 +0200
Message-Id: <1406807385-5168-2-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1406807385-5168-1-git-send-email-jmarchan@redhat.com>
References: <1406807385-5168-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a while  ago, get_scan_ratio() has been renamed get_scan_count(),
however a comment in shrink_active_list() still mention it. This patch
fixes the outdated comment.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d698f4f..079918d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1759,7 +1759,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	 * Count referenced pages from currently used mappings as rotated,
 	 * even though only some of them are actually re-activated.  This
 	 * helps balance scan pressure between file and anonymous pages in
-	 * get_scan_ratio.
+	 * get_scan_count.
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
-- 
1.9.3

