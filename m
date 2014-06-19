Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbaFSGck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:32:40 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52806 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaFSGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:32:38 -0400
From: Lei Li <lilei@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz,
        Lei Li <lilei@linux.vnet.ibm.com>
Subject: [PATCH] Documentation: Update remove_from_page_cache with delete_from_page_cache
Date: Thu, 19 Jun 2014 14:32:25 +0800
Message-Id: <1403159545-8029-1-git-send-email-lilei@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061906-2000-0000-0000-0000009A107B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove_from_page_cache has been renamed to delete_from_page_cache
since Commit 702cfbf9 ("mm: goodbye remove_from_page_cache()"), adapt
to it in Memcg documentation.

Signed-off-by: Lei Li <lilei@linux.vnet.ibm.com>
---
 Documentation/cgroups/memcg_test.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index 80ac454..b2d6ccc 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -171,10 +171,10 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	- add_to_page_cache_locked().
 
 	uncharged at
-	- __remove_from_page_cache().
+	- __delete_from_page_cache().
 
 	The logic is very clear. (About migration, see below)
-	Note: __remove_from_page_cache() is called by remove_from_page_cache()
+	Note: __delete_from_page_cache() is called by delete_from_page_cache()
 	and __remove_mapping().
 
 6. Shmem(tmpfs) Page Cache
-- 
1.8.5.3

