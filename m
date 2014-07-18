Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbaGRKiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:38:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761467AbaGRKiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:16 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 7/8] GFS2: memcontrol: Spelling s/invlidate/invalidate/
Date: Fri, 18 Jul 2014 11:37:44 +0100
Message-Id: <1405679865-15728-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
References: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: cluster-devel@redhat.com
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index fc11007..2ffc67d 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -234,8 +234,8 @@ static void inode_go_sync(struct gfs2_glock *gl)
  * inode_go_inval - prepare a inode glock to be released
  * @gl: the glock
  * @flags:
- * 
- * Normally we invlidate everything, but if we are moving into
+ *
+ * Normally we invalidate everything, but if we are moving into
  * LM_ST_DEFERRED from LM_ST_SHARED or LM_ST_EXCLUSIVE then we
  * can keep hold of the metadata, since it won't have changed.
  *
-- 
1.8.3.1

