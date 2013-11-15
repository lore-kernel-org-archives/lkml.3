Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab3KOH07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:26:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab3KOH0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:26:35 -0500
Date: Thu, 14 Nov 2013 23:26:04 -0800
From: tip-bot for Joe Perches <tipbot@zytor.com>
Message-ID: <tip-7486d6da09d4d76d49c68826c97578246936092b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joe@perches.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1384469985.2897.32.camel@joe-AO722>
References: <1384469985.2897.32.camel@joe-AO722>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] MAINTAINERS:
  Update file patterns in the lockdep and scheduler entries
Git-Commit-ID: 7486d6da09d4d76d49c68826c97578246936092b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:26:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7486d6da09d4d76d49c68826c97578246936092b
Gitweb:     http://git.kernel.org/tip/7486d6da09d4d76d49c68826c97578246936092b
Author:     Joe Perches <joe@perches.com>
AuthorDate: Thu, 14 Nov 2013 14:59:45 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 15 Nov 2013 07:15:26 +0100

MAINTAINERS: Update file patterns in the lockdep and scheduler entries

Propagate the file movement effects of the following commits:

  7a6354e241d8 sched: Move wait.c into kernel/sched/
  8eddac3f1037 locking: Move the lockdep code to kernel/locking/

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1384469985.2897.32.camel@joe-AO722
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f3ef1d1..3f85561 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5236,7 +5236,7 @@ S:	Maintained
 F:	Documentation/lockdep*.txt
 F:	Documentation/lockstat.txt
 F:	include/linux/lockdep.h
-F:	kernel/lockdep*
+F:	kernel/locking/
 
 LOGICAL DISK MANAGER SUPPORT (LDM, Windows 2000/XP/Vista Dynamic Disks)
 M:	"Richard Russon (FlatCap)" <ldm@flatcap.org>
@@ -7361,7 +7361,6 @@ S:	Maintained
 F:	kernel/sched/
 F:	include/linux/sched.h
 F:	include/uapi/linux/sched.h
-F:	kernel/wait.c
 F:	include/linux/wait.h
 
 SCORE ARCHITECTURE
