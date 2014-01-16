Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaAPB1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:27:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:49062 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbaAPBZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:25:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="439548599"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 20/22] ext4: Fix typos
Date: Wed, 15 Jan 2014 20:24:38 -0500
Message-Id: <2b60800c105942801e3dc6c70c1d2aa061d6bc68.1389779962.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment fix only

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8b73d77..cae40af 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3720,7 +3720,7 @@ void ext4_truncate(struct inode *inode)
 
 	/*
 	 * There is a possibility that we're either freeing the inode
-	 * or it completely new indode. In those cases we might not
+	 * or it's a completely new inode. In those cases we might not
 	 * have i_mutex locked because it's not necessary.
 	 */
 	if (!(inode->i_state & (I_NEW|I_FREEING)))
-- 
1.8.5.2

