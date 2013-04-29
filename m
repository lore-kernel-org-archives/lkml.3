Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab3D2NGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:06:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47742 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3D2NGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:06:05 -0400
From: Rami Rosen <ramirose@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Rami Rosen <ramirose@gmail.com>
Subject: [PATCH] sysfs: kill sysfs_sb declaration in fs/sysfs/inode.c.
Date: Mon, 29 Apr 2013 16:05:32 +0300
Message-Id: <1367240732-27365-1-git-send-email-ramirose@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes sysfs_sb declaration from fs/sysfs/inode.c
(due to 0f4288ec6fcc1a47d1fa0241ec1c6dacd5a09e96,
 "Kill unused sysfs_sb variable").

Signed-off-by: Rami Rosen <ramirose@gmail.com>
---
 fs/sysfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 0ce3ccf..3e2837a 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -24,8 +24,6 @@
 #include <linux/security.h>
 #include "sysfs.h"
 
-extern struct super_block * sysfs_sb;
-
 static const struct address_space_operations sysfs_aops = {
 	.readpage	= simple_readpage,
 	.write_begin	= simple_write_begin,
-- 
1.8.1.4

