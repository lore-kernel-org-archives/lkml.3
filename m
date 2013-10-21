Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3JUHzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 03:55:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35892 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750876Ab3JUHzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 03:55:08 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: viro@zeniv.linux.org.uk
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffm@suse.com, marco.stornelli@gmail.com, jack@suse.cz,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] reiserfs: remove duplicate define
Date: Mon, 21 Oct 2013 09:54:57 +0200
Message-Id: <1382342097-2991-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a duplicate define in fs/reiserfs/reiserfs.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 fs/reiserfs/reiserfs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index f8adaee..a27d69b 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -597,7 +597,6 @@ void reiserfs_file_buffer(struct buffer_head *bh, int list);
 extern struct file_system_type reiserfs_fs_type;
 int reiserfs_resize(struct super_block *, unsigned long);
 
-#define CARRY_ON                0
 #define SCHEDULE_OCCURRED       1
 
 #define SB_BUFFER_WITH_SB(s) (REISERFS_SB(s)->s_sbh)
-- 
1.8.1.2

