Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab3CNMa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:30:58 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60588 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3CNMa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:30:57 -0400
Date: Thu, 14 Mar 2013 18:00:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: mm: trivial: Remove duplicate declaration for migrate_misplaced_page
Message-ID: <20130314123046.GA13822@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031412-3620-0000-0000-0000019FB2C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just noticied that e14808b49 added a duplicate extern declaration for
migrate_misplaced_page()
    
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index a405d3dc..086bd33 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -93,7 +93,6 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 #ifdef CONFIG_NUMA_BALANCING
 extern int migrate_misplaced_page(struct page *page, int node);
-extern int migrate_misplaced_page(struct page *page, int node);
 extern bool migrate_ratelimited(int node);
 #else
 static inline int migrate_misplaced_page(struct page *page, int node)

