Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaI0QUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 12:20:49 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:64169 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbaI0QUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 12:20:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqISAAPjJlRXQy06/2dsb2JhbABfgw62CwUBcppRBAJ9FwF7hGAjgRo3iEIBryuPeoYSigwdhDUFkT2La4xAiR2DZTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/hfs/hfs_fs.h: remove redundant sys_tz declaration
Date: Sat, 27 Sep 2014 18:20:44 +0200
Message-Id: <1411834844-17845-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_tz is already declared in include/linux/time.h

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hfs/hfs_fs.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 0524cda..95d2552 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -242,8 +242,6 @@ extern int hfs_mac2asc(struct super_block *, char *, const struct hfs_name *);
 /* super.c */
 extern void hfs_mark_mdb_dirty(struct super_block *sb);
 
-extern struct timezone sys_tz;
-
 /*
  * There are two time systems.  Both are based on seconds since
  * a particular time/date.
-- 
1.9.3

