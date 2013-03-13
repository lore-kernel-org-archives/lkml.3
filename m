Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab3CMRJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:09:37 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:48945 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740Ab3CMRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:09:35 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] squashfs: Simplify info in the logs when loaded
Date: Wed, 13 Mar 2013 18:09:24 +0100
Message-Id: <1363194564-5901-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.2.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/squashfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 260e392..9747764 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -447,8 +447,7 @@ static int __init init_squashfs_fs(void)
 		return err;
 	}
 
-	printk(KERN_INFO "squashfs: version 4.0 (2009/01/31) "
-		"Phillip Lougher\n");
+	printk(KERN_INFO "squashfs: loaded\n");
 
 	return 0;
 }
-- 
1.8.2.rc3

