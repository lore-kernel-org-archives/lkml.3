Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab3JCGS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:18:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41550 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3JCGS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:18:27 -0400
Date: Thu, 03 Oct 2013 07:18:26 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 06/17] fs/namespace.c: bury long-dead define
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcF0-000898-9P@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


MNT_WRITER_UNDERFLOW_LIMIT has been missed 4 years ago when it became unused.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f00d9f6..8ea6676 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -63,8 +63,6 @@ static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 	return tmp & (HASH_SIZE - 1);
 }
 
-#define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
-
 /*
  * allocation is serialized by namespace_sem, but we need the spinlock to
  * serialize with freeing.
-- 
1.7.2.5


