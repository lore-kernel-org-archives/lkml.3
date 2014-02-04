Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaBDBvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:51:33 -0500
Received: from sh.osrg.net ([192.16.179.4]:59876 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaBDBvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:51:31 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH] nilfs2: add description of NILFS_IOCTL_SET_SUINFO ioctl
Date: Tue,  4 Feb 2014 10:50:00 +0900
Message-Id: <1391478600-7512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Tue, 04 Feb 2014 10:51:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description of NILFS_IOCTL_SET_SUINFO ioctl in
Documentation/filesystems/nilfs2.txt to make it up-to-date.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andreas Rohner <andreas.rohner@gmx.net>
---
 Documentation/filesystems/nilfs2.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index 06887d4..8b887ae 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -111,6 +111,13 @@ Table of NILFS2 specific ioctls
 			        nilfs_resize utilities and by nilfs_cleanerd
 			        daemon.
 
+ NILFS_IOCTL_SET_SUINFO         Modify segment usage info of requested
+				segments. This ioctl is used by
+				nilfs_cleanerd daemon to skip unnecessary
+				cleaning operation of segments and reduce
+				performance penalty or wear of flash device
+				due to redundant move of in-use blocks.
+
  NILFS_IOCTL_GET_SUSTAT         Return segment usage statistics. This ioctl
 			        is used in lssu, nilfs_resize utilities and
 			        by nilfs_cleanerd daemon.
-- 
1.7.9.3

