Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3JRJ1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:27:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:43752 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab3JRJ1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:27:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,521,1378882800"; 
   d="scan'208";a="418855249"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 1/2] f2fs: use true and false for boolean value
Date: Fri, 18 Oct 2013 17:24:07 +0800
Message-Id: <1382088248-10615-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/segment.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3b20359..862fef3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1277,9 +1277,9 @@ static bool flush_sits_in_journal(struct f2fs_sb_info *sbi)
 			__mark_sit_entry_dirty(sbi, segno);
 		}
 		update_sits_in_cursum(sum, -sits_in_cursum(sum));
-		return 1;
+		return true;
 	}
-	return 0;
+	return false;
 }
 
 /*
-- 
1.7.9.5

