Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaCKKRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:17:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbaCKKL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678277"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 05/17] locktorture: Replace hardcoding of 19 with MAX_NICE.
Date: Tue, 11 Mar 2014 18:09:13 +0800
Message-Id: <cbb322d475b9e22430624892dab294d3096e7bfd.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:35,
	Serialize complete at 2014/03/11 18:08:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/locking/locktorture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index f26b1a1..23343be 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -216,7 +216,7 @@ static int lock_torture_writer(void *arg)
 	static DEFINE_TORTURE_RANDOM(rand);
 
 	VERBOSE_TOROUT_STRING("lock_torture_writer task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	do {
 		schedule_timeout_uninterruptible(1);
-- 
1.8.2.1

