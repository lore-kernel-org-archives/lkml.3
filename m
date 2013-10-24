Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3JXPtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:49:55 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65153 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab3JXPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:49:48 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/34] sysfs: remove unused sysfs_get_dentry() prototype
Date: Thu, 24 Oct 2013 11:49:09 -0400
Message-Id: <1382629780-10006-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_get_dentry() has been gone for years now.  Remove the left-over
prototype.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/sysfs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index bdce845..e0753e5 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -165,7 +165,6 @@ extern const struct dentry_operations sysfs_dentry_ops;
 extern const struct file_operations sysfs_dir_operations;
 extern const struct inode_operations sysfs_dir_inode_operations;
 
-struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
 struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 void sysfs_put_active(struct sysfs_dirent *sd);
 void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt);
-- 
1.8.3.1

