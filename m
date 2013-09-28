Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3I1Vus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:50:48 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:40930 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab3I1Vtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:49:49 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/14] sysfs: remove unused sysfs_buffer->pos
Date: Sat, 28 Sep 2013 17:49:31 -0400
Message-Id: <1380404984-31858-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1656a79..81e3f72 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -44,7 +44,6 @@ struct sysfs_open_dirent {
 
 struct sysfs_buffer {
 	size_t			count;
-	loff_t			pos;
 	char			*page;
 	const struct sysfs_ops	*ops;
 	struct mutex		mutex;
-- 
1.8.3.1

