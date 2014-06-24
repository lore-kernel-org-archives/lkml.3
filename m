Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaFXJRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:17:54 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50135 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaFXJRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:17:52 -0400
From: Lei Li <lilei@linux.vnet.ibm.com>
To: mhocko@suse.cz
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lei Li <lilei@linux.vnet.ibm.com>
Subject: [PATCH] Documentation: remove remove_from_page_cache note
Date: Tue, 24 Jun 2014 17:17:42 +0800
Message-Id: <1403601462-32167-1-git-send-email-lilei@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062409-1396-0000-0000-00000518AE93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove this note as remove_from_page_cache has been renamed to
delete_from_page_cache since Commit 702cfbf9 ("mm: goodbye
remove_from_page_cache()"), and it doesn't serve any useful
purpose.

Signed-off-by: Lei Li <lilei@linux.vnet.ibm.com>
---
 Documentation/cgroups/memcg_test.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index 8870b02..67c11a3 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -82,8 +82,6 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	- add_to_page_cache_locked().
 
 	The logic is very clear. (About migration, see below)
-	Note: __remove_from_page_cache() is called by remove_from_page_cache()
-	and __remove_mapping().
 
 6. Shmem(tmpfs) Page Cache
 	The best way to understand shmem's page state transition is to read
-- 
1.8.5.3

