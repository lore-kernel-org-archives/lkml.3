Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3IQJPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:15:25 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55858 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3IQJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:15:23 -0400
From: baisong zhong <baisong.zhong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, zhongbaisong <baisong.zhong@gmail.com>
Subject: [PATCH]    adjust the error labels to make it clear
Date: Tue, 17 Sep 2013 17:15:13 +0800
Message-Id: <1379409313-1917-1-git-send-email-baisong.zhong@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: zhongbaisong <baisong.zhong@gmail.com>

Signed-off-by: zhongbaisong <baisong.zhong@gmail.com>
---
 fs/sysfs/mount.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index afd8327..f6681a6 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -182,12 +182,12 @@ int __init sysfs_init(void)
 		}
 	} else
 		goto out_err;
-out:
-	return err;
+
 out_err:
 	kmem_cache_destroy(sysfs_dir_cachep);
 	sysfs_dir_cachep = NULL;
-	goto out;
+out:
+	return err;
 }
 
 #undef sysfs_get
-- 
1.7.0.4

