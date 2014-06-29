Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaF2KV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:21:56 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63471 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaF2KVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:21:50 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH -trivial 4/4] GFS2: memcontrol: Spelling s/invlidate/invalidate/
Date: Sun, 29 Jun 2014 12:21:39 +0200
Message-Id: <1404037299-31570-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404037299-31570-1-git-send-email-geert@linux-m68k.org>
References: <1404037299-31570-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/gfs2/glops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index fc1100781bbc..2ffc67dce87f 100644
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
1.9.1

