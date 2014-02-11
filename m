Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaBKKqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:46:42 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63015 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaBKKql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:46:41 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: sjenning@linux.vnet.ibm.com, trivial@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/2] mm/zswap: fix trivial typo and arrange indentation
Date: Tue, 11 Feb 2014 19:46:29 +0900
Message-Id: <1392115590-15260-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e55bab9..5b22453 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -160,14 +160,14 @@ static void zswap_comp_exit(void)
  * rbnode - links the entry into red-black tree for the appropriate swap type
  * refcount - the number of outstanding reference to the entry. This is needed
  *            to protect against premature freeing of the entry by code
- *            concurent calls to load, invalidate, and writeback.  The lock
+ *            concurrent calls to load, invalidate, and writeback.  The lock
  *            for the zswap_tree structure that contains the entry must
  *            be held while changing the refcount.  Since the lock must
  *            be held, there is no reason to also make refcount atomic.
  * offset - the swap offset for the entry.  Index into the red-black tree.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * length - the length in bytes of the compressed page data.  Needed during
- *           decompression
+ *          decompression
  */
 struct zswap_entry {
 	struct rb_node rbnode;
-- 
1.8.1.2

