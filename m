Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaECU0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:26:45 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:20727 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178AbaECU0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:26:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoTAKpPZVNXQD6Q/2dsb2JhbABZgwaDPagrCgUBmgYCAoERF3SCZhwjGIECJBOIRQHKAYVWiHyERgEDjxqKGQGSdIM2Ow
Date: Sat, 3 May 2014 22:26:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/mempolicy.c: parameter doc uniformization
Message-Id: <20140503222634.fbe639df3ae6cdd76843f54a@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fixes kernel-doc warning

Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/mempolicy.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 78e1472..2bf0787 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1606,9 +1606,9 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulong_t, start, compat_ulong_t, len,
 
 /*
  * get_vma_policy(@task, @vma, @addr)
- * @task - task for fallback if vma policy == default
- * @vma   - virtual memory area whose policy is sought
- * @addr  - address in @vma for shared policy lookup
+ * @task: task for fallback if vma policy == default
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup
  *
  * Returns effective policy for a VMA at specified address.
  * Falls back to @task or system default policy, as necessary.
@@ -1854,11 +1854,11 @@ int node_random(const nodemask_t *maskp)
 #ifdef CONFIG_HUGETLBFS
 /*
  * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
- * @vma = virtual memory area whose policy is sought
- * @addr = address in @vma for shared policy lookup and interleave policy
- * @gfp_flags = for requested zone
- * @mpol = pointer to mempolicy pointer for reference counted mempolicy
- * @nodemask = pointer to nodemask pointer for MPOL_BIND nodemask
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup and interleave policy
+ * @gfp_flags: for requested zone
+ * @mpol: pointer to mempolicy pointer for reference counted mempolicy
+ * @nodemask: pointer to nodemask pointer for MPOL_BIND nodemask
  *
  * Returns a zonelist suitable for a huge page allocation and a pointer
  * to the struct mempolicy for conditional unref after allocation.
@@ -2270,9 +2270,9 @@ static void sp_free(struct sp_node *n)
 /**
  * mpol_misplaced - check whether current page node is valid in policy
  *
- * @page   - page to be checked
- * @vma    - vm area where page mapped
- * @addr   - virtual address where page mapped
+ * @page: page to be checked
+ * @vma: vm area where page mapped
+ * @addr: virtual address where page mapped
  *
  * Lookup current policy node id for vma,addr and "compare to" page's
  * node id.
-- 
1.8.4.5

