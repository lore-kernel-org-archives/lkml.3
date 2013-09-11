Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3IKMmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:42:44 -0400
Received: from asav4.altibox.net ([81.167.36.153]:52414 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3IKMmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:42:43 -0400
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>, LKML Doc <linux-doc@vger.kernel.org>
Cc: Henrik Austad <henrik@austad.us>
Subject: [PATCH] mm: update 00-INDEX
Date: Wed, 11 Sep 2013 14:42:20 +0200
Message-Id: <1378903340-9483-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following files moved files out of Documentation/vm/
c6dd897f ("mm: move page-types.c from Documentation to tools/vm")
f0f57b2b ("move hugepage test examples to tools/testing/selftests/vm)

Remove these files from vm/00-INDEX.

The following commits added new files do Documentation/vm/
4fe4746a ("mm/fs: cleancache documentation") added vm/cleancache.txt
d65bfacb ("mm: highmem documentation") added vm/highmem.txt
1c9bf22c ("thp: transparent hugepage support documentation") added
           vm/transhuge.txt
0f8975ec ("mm: soft-dirty bits for user memory changes tracking")
61b0d760 ("zswap: add documentation")
27c6aec2 ("mm: frontswap: config and doc files")

Add the missing documentation-files with a short description to 00-INDEX

Signed-off-by: Henrik Austad <henrik@austad.us>
---
 Documentation/vm/00-INDEX |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/Documentation/vm/00-INDEX b/Documentation/vm/00-INDEX
index 5481c8b..a39d066 100644
--- a/Documentation/vm/00-INDEX
+++ b/Documentation/vm/00-INDEX
@@ -4,10 +4,12 @@ active_mm.txt
 	- An explanation from Linus about tsk->active_mm vs tsk->mm.
 balance
 	- various information on memory balancing.
-hugepage-mmap.c
-	- Example app using huge page memory with the mmap system call.
-hugepage-shm.c
-	- Example app using huge page memory with Sys V shared memory system calls.
+cleancache.txt
+	- Intro to cleancache and page-granularity victim cache.
+frontswap.txt
+	- Outline frontswap, part of the transcendent memory frontend.
+highmem.txt
+	- Outline of highmem and common issues.
 hugetlbpage.txt
 	- a brief summary of hugetlbpage support in the Linux kernel.
 hwpoison.txt
@@ -16,21 +18,23 @@ ksm.txt
 	- how to use the Kernel Samepage Merging feature.
 locking
 	- info on how locking and synchronization is done in the Linux vm code.
-map_hugetlb.c
-	- an example program that uses the MAP_HUGETLB mmap flag.
 numa
 	- information about NUMA specific code in the Linux vm.
 numa_memory_policy.txt
 	- documentation of concepts and APIs of the 2.6 memory policy support.
 overcommit-accounting
 	- description of the Linux kernels overcommit handling modes.
-page-types.c
-	- Tool for querying page flags
 page_migration
 	- description of page migration in NUMA systems.
 pagemap.txt
 	- pagemap, from the userspace perspective
 slub.txt
 	- a short users guide for SLUB.
+soft-dirty.txt
+	- short explanation for soft-dirty PTEs
+transhuge.txt
+	- Transparent Hugepage Support, alternative way of using hugepages.
 unevictable-lru.txt
 	- Unevictable LRU infrastructure
+zswap.txt
+	- Intro to compressed cache for swap pages
-- 
1.7.10.4

