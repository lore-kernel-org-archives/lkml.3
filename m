Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3JDRgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:36:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3JDRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:36:36 -0400
Date: Fri, 4 Oct 2013 10:36:07 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-0ix315c7qcz88slmnrpshvmf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] MAINTAINERS, sched: Update file pattern
Git-Commit-ID: c2eb505b9b24d5e912798c033814ff429b1a8823
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:36:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2eb505b9b24d5e912798c033814ff429b1a8823
Gitweb:     http://git.kernel.org/tip/c2eb505b9b24d5e912798c033814ff429b1a8823
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:49:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:16:27 +0200

MAINTAINERS, sched: Update file pattern

Took a while to sort out these bits and we'd like to be Cc:-ed on
future modifications to the waitqueue APIs and all that.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-0ix315c7qcz88slmnrpshvmf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..efdfcb2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7256,6 +7256,8 @@ S:	Maintained
 F:	kernel/sched/
 F:	include/linux/sched.h
 F:	include/uapi/linux/sched.h
+F:	kernel/wait.c
+F:	include/linux/wait.h
 
 SCORE ARCHITECTURE
 M:	Chen Liqin <liqin.chen@sunplusct.com>
