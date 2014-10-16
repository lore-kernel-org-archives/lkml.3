Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaJPMKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:10:36 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36132 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJPMKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:10:35 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: jack@suse.cz, linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] quota: Fix spelling typo in module description in quota_tree.c
Date: Thu, 16 Oct 2014 21:10:12 +0900
Message-Id: <1413461412-19263-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.443.g670a3c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo in module description.
"Quota trie support" should be "Quota tree support",
since the file name is quota_tree.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/quota/quota_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
index d65877f..60ecc39 100644
--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -17,7 +17,7 @@
 #include "quota_tree.h"
 
 MODULE_AUTHOR("Jan Kara");
-MODULE_DESCRIPTION("Quota trie support");
+MODULE_DESCRIPTION("Quota tree support");
 MODULE_LICENSE("GPL");
 
 #define __QUOTA_QT_PARANOIA
-- 
2.1.2.443.g670a3c1

