Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbaGBUGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:06:49 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:27143 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbaGBUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:06:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4IABFltFNXQBPR/2dsb2JhbABagw2sZgUBAQEBAQEFAW4BmWeBBxd1hGAjgRo3iEYBx2EXhXCJMh2ELQWabZQKg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>,
        cluster-devel@redhat.com
Subject: [PATCH 1/1] fs/gfs2/rgrp.c: kernel-doc warning fixes
Date: Wed,  2 Jul 2014 22:05:27 +0200
Message-Id: <1404331527-4068-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/gfs2/rgrp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index db629d1..f4cb9c0 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -337,7 +337,7 @@ static bool gfs2_unaligned_extlen(struct gfs2_rbm *rbm, u32 n_unaligned, u32 *le
 
 /**
  * gfs2_free_extlen - Return extent length of free blocks
- * @rbm: Starting position
+ * @rrbm: Starting position
  * @len: Max length to check
  *
  * Starting at the block specified by the rbm, see how many free blocks
@@ -2522,7 +2522,7 @@ void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state)
 
 /**
  * gfs2_rlist_free - free a resource group list
- * @list: the list of resource groups
+ * @rlist: the list of resource groups
  *
  */
 
-- 
1.8.4.5

