Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaBKHf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:35:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaBKHfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:09 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505341"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4/9] sched: prio: Add spaces before and after operator of '-'.
Date: Tue, 11 Feb 2014 15:34:48 +0800
Message-Id: <bcbf88bb25b5423e8d33b3aa0c2e829a23d56c76.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:04,
	Serialize complete at 2014/02/11 15:33:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/prio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index ac32258..1bf9935 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -37,7 +37,7 @@
  * can work with better when scaling various scheduler parameters,
  * it's a [ 0 ... 39 ] range.
  */
-#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
+#define USER_PRIO(p)		((p) - MAX_RT_PRIO)
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 
-- 
1.8.2.1

