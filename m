Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3ILC3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 22:29:23 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54821 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3ILC3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 22:29:20 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, kay@vrfy.org, ebiederm@xmission.com,
        netdev@vger.kernel.org, lizefan@huawei.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] sysfs: drop semicolon from to_sysfs_dirent() definition
Date: Wed, 11 Sep 2013 22:29:03 -0400
Message-Id: <1378952949-7900-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378952949-7900-1-git-send-email-tj@kernel.org>
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The expansion of to_sysfs_dirent() contains an unncessary trailing
semicolon making it impossible to use in the middle of statements.
Drop it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4d83ced..834c64c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -28,7 +28,7 @@
 DEFINE_MUTEX(sysfs_mutex);
 DEFINE_SPINLOCK(sysfs_assoc_lock);
 
-#define to_sysfs_dirent(X) rb_entry((X), struct sysfs_dirent, s_rb);
+#define to_sysfs_dirent(X) rb_entry((X), struct sysfs_dirent, s_rb)
 
 static DEFINE_SPINLOCK(sysfs_ino_lock);
 static DEFINE_IDA(sysfs_ino_ida);
-- 
1.8.3.1

