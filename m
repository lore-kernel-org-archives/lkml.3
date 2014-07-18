Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbaGRKiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:38:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761494AbaGRKiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 8/8] GFS2: fs/gfs2/rgrp.c: kernel-doc warning fixes
Date: Fri, 18 Jul 2014 11:37:45 +0100
Message-Id: <1405679865-15728-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
References: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Cc: cluster-devel@redhat.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

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
1.8.3.1

