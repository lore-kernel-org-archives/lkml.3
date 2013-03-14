Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab3CNP0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:26:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36661 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758124Ab3CNP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:26:22 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: Remove __attribute__ ((packed))
Date: Thu, 14 Mar 2013 15:26:19 +0000
Message-Id: <1363274779-20671-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point having this.  The space gains are trivial if there
are any at all.

Change-Id: Ib4b1320420f780dcf5b9a1e4b05f5805691c4d9f
Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index dd5ed6c..383fc00 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -31,7 +31,7 @@ struct regcache_rbtree_node {
 	void *block;
 	/* number of registers available in the block */
 	unsigned int blklen;
-} __attribute__ ((packed));
+};
 
 struct regcache_rbtree_ctx {
 	struct rb_root root;
-- 
1.8.1.5

