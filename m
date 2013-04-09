Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936780Ab3DIX31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:29:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38928 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936667Ab3DIX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:28:55 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 07/10] mm/page_alloc: relocate comment to be directly above code it refers to.
Date: Tue,  9 Apr 2013 16:28:16 -0700
Message-Id: <1365550099-6795-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040923-2398-0000-0000-0000131C8B2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a2f2207..6e52e67 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3680,12 +3680,12 @@ void __ref build_all_zonelists(pg_data_t *pgdat, struct zone *zone)
 		mminit_verify_zonelist();
 		cpuset_init_current_mems_allowed();
 	} else {
-		/* we have to stop all cpus to guarantee there is no user
-		   of zonelist */
 #ifdef CONFIG_MEMORY_HOTPLUG
 		if (zone)
 			setup_zone_pageset(zone);
 #endif
+		/* we have to stop all cpus to guarantee there is no user
+		   of zonelist */
 		stop_machine(__build_all_zonelists, pgdat, NULL);
 		/* cpuset refresh routine should be here */
 	}
-- 
1.8.2

