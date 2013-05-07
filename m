Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab3EGC37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:29:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760161Ab3EGCT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201766"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 19/48] Audit: remove duplicate comments
Date: Tue, 7 May 2013 10:20:40 +0800
Message-Id: <1367893269-9308-20-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:28,
	Serialize complete at 2013/05/07 10:18:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove it.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 62f244b..5ac9acd 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1154,13 +1154,6 @@ static void wait_for_auditd(unsigned long sleep_time)
 	remove_wait_queue(&init_user_ns.audit.backlog_wait, &wait);
 }
 
-/* Obtain an audit buffer.  This routine does locking to obtain the
- * audit buffer, but then no locking is required for calls to
- * audit_log_*format.  If the tsk is a task that is currently in a
- * syscall, then the syscall is marked as auditable and an audit record
- * will be written at syscall exit.  If there is no associated task, tsk
- * should be NULL. */
-
 /**
  * audit_log_start - obtain an audit buffer
  * @ctx: audit_context (may be NULL)
-- 
1.8.1.4

