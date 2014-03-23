Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaCWTMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:12:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:9372 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbaCWTJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:09:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,715,1389772800"; 
   d="scan'208";a="505021435"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v7 21/22] ext4: Fix typos
Date: Sun, 23 Mar 2014 15:08:47 -0400
Message-Id: <2b2c5467283817503fede11d12cba8aef912c9c5.1395591795.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1395591795.git.matthew.r.wilcox@intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395591795.git.matthew.r.wilcox@intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment fix only

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9462730..14a9744 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3691,7 +3691,7 @@ void ext4_truncate(struct inode *inode)
 
 	/*
 	 * There is a possibility that we're either freeing the inode
-	 * or it completely new indode. In those cases we might not
+	 * or it's a completely new inode. In those cases we might not
 	 * have i_mutex locked because it's not necessary.
 	 */
 	if (!(inode->i_state & (I_NEW|I_FREEING)))
-- 
1.9.0

