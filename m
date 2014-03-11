Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaCKJXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:23:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41970 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbaCKJXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:23:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677991"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        devel@driverdev.osuosl.org, Xiong Zhou <jencce.kernel@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Cyril Roelandt <tipecaml@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 14/16] driver/staging/lustre: Replace hardcoding of -20 with MIN_NICE.
Date: Tue, 11 Mar 2014 17:20:35 +0800
Message-Id: <547d173890fe23858b8c34b97c4bbcce81c18df1.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:20:19,
	Serialize complete at 2014/03/11 17:20:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: devel@driverdev.osuosl.org
cc: Xiong Zhou <jencce.kernel@gmail.com>
cc: Andreas Dilger <andreas.dilger@intel.com>
cc: Cyril Roelandt <tipecaml@gmail.com>
cc: Kent Overstreet <kmo@daterainc.com>
cc: Peng Tao <bergwolf@gmail.com>
---
 drivers/staging/lustre/lustre/llite/lloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 0718905..e40fc84 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -407,7 +407,7 @@ static int loop_thread(void *data)
 	int refcheck;
 	int ret = 0;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	lo->lo_state = LLOOP_BOUND;
 
-- 
1.8.2.1

