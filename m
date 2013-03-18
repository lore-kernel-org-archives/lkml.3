Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3CRJTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:19:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45978 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab3CRJTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:19:32 -0400
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 2/2] btrfs: Cleanup some redundant codes in btrfs_log_inode()
Date: Mon, 18 Mar 2013 17:18:10 +0800
Message-Id: <1363598290-12258-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363598290-12258-1-git-send-email-zwu.kernel@gmail.com>
References: <1363598290-12258-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031809-5806-0000-0000-000020608A0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/tree-log.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 451fad9..83d4e1d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3614,8 +3614,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	bool fast_search = false;
 	u64 ino = btrfs_ino(inode);
 
-	log = root->log_root;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.7.11.7

