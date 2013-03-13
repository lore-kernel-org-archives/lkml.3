Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab3CMTrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:47:25 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:36139 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMTrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:47:23 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] overlayfs: Print info into the logs when loaded
Date: Wed, 13 Mar 2013 20:47:14 +0100
Message-Id: <1363204034-2442-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.2.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/overlayfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 482c26f..e30141f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -674,6 +674,8 @@ MODULE_ALIAS_FS("overlayfs");
 
 static int __init ovl_init(void)
 {
+	printk(KERN_INFO "overlayfs: loaded\n");
+
 	return register_filesystem(&ovl_fs_type);
 }
 
-- 
1.8.2.rc3

