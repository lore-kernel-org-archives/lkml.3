Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3KJPTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:19:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:55854 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3KJPTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:19:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="432794280"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>
Subject: [f2fs-dev][PATCH V2 6/6] f2fs: update f2fs Documentation
Date: Sun, 10 Nov 2013 23:13:21 +0800
Message-Id: <1384096401-25169-7-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huajun Li <huajun.li@intel.com>

This patch describes the inline_data support in f2fs document.

Signed-off-by: Huajun Li <huajun.li@intel.com>
---
 Documentation/filesystems/f2fs.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index a3fe811..9849372 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -120,6 +120,8 @@ active_logs=%u         Support configuring the number of active logs. In the
 disable_ext_identify   Disable the extension list configured by mkfs, so f2fs
                        does not aware of cold files such as media files.
 inline_xattr           Enable the inline xattrs feature.
+inline_data            Enable the inline data feature: New created small(<~3.4k)
+                       files can be written into inode block.
 
 ================================================================================
 DEBUGFS ENTRIES
-- 
1.7.9.5

