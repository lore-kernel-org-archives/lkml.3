Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3JAVmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:42:20 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:50751 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3JAVmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:17 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/15] sysfs: remove unused sysfs_buffer->pos
Date: Tue,  1 Oct 2013 17:41:55 -0400
Message-Id: <1380663729-18243-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
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

