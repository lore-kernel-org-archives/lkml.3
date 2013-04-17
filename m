Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3DQE1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 00:27:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41019 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3DQE1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 00:27:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,490,1363104000"; 
   d="scan'208";a="7074594"
From: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Ren Mingxin <renmx@cn.fujitsu.com>,
        James Bottomley <jbottomley@parallels.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>,
        DM-DEV <dm-devel@redhat.com>, SCSI <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi_dh: remove unused declaration dm_pg_init_complete()
Date: Wed, 17 Apr 2013 12:29:09 +0800
Message-Id: <1366172949-14958-1-git-send-email-renmx@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/17 12:25:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/17 12:25:45,
	Serialize complete at 2013/04/17 12:25:45
To: agk@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dm_pg_init_complete()'s declaration as it is
not needed anymore since 2651f5d7d3bc5120a439e498f131e4d731f99b3e.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/md/dm-mpath.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.h b/drivers/md/dm-mpath.h
index e230f71..9c36d0f 100644
--- a/drivers/md/dm-mpath.h
+++ b/drivers/md/dm-mpath.h
@@ -16,7 +16,4 @@ struct dm_path {
 	void *pscontext;	/* For path-selector use */
 };
 
-/* Callback for hwh_pg_init_fn to use when complete */
-void dm_pg_init_complete(struct dm_path *path, unsigned err_flags);
-
 #endif
-- 
1.7.1

