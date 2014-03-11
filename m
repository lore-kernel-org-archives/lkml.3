Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaCKFFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:05:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbaCKFBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:01:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676439"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 13/15] sched/prio: Add a macro named RLIMIT_TO_NICE in prio.h.
Date: Tue, 11 Mar 2014 12:59:28 +0800
Message-Id: <602ae6aa7d5dde0c703d42cac708bc8c844ffb54.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:56,
	Serialize complete at 2014/03/11 12:58:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/sched/prio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index 8e78c47..e34bf0a 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -45,5 +45,6 @@
  * Convert nice value [19,-20] to rlimit style value [1,40].
  */
 #define NICE_TO_RLIMIT(nice)	(MAX_NICE - nice + 1)
+#define RLIMIT_TO_NICE(prio)	(MAX_NICE - prio + 1)
 
 #endif /* _SCHED_PRIO_H */
-- 
1.8.2.1

