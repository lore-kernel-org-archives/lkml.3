Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3EMDOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:14:47 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:31517 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3EMDOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:14:46 -0400
From: Warner Wang <warner.wang@hp.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Warner Wang <warner.wang@hp.com>
Subject: [PATCH] sysfs: sysfs_link_sibling(): fix typo in comment
Date: Mon, 13 May 2013 11:11:05 +0800
Message-Id: <1368414665-29566-1-git-send-email-warner.wang@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo subling->sibling in the comment of sysfs_link_sibling().

Signed-off-by: Warner Wang <warner.wang@hp.com>
---
 fs/sysfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e8e0e71..17c9a70 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -74,7 +74,7 @@ static int sysfs_sd_compare(const struct sysfs_dirent *left,
 }
 
 /**
- *	sysfs_link_subling - link sysfs_dirent into sibling rbtree
+ *	sysfs_link_sibling - link sysfs_dirent into sibling rbtree
  *	@sd: sysfs_dirent of interest
  *
  *	Link @sd into its sibling rbtree which starts from
-- 
1.7.1

