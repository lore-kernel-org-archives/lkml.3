Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3DNQJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:09:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3DNQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:09:34 -0400
Date: Sun, 14 Apr 2013 09:09:02 -0700
From: tip-bot for Andrei Epure <tipbot@zytor.com>
Message-ID: <tip-9b89f6ba2ab56e4d9c00e7e591d6bc333137895e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, epure.andrei@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, epure.andrei@gmail.com, tglx@linutronix.de
In-Reply-To: <1365701429-4721-1-git-send-email-epure.andrei@gmail.com>
References: <1365701429-4721-1-git-send-email-epure.andrei@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Document task_struct::personality field
Git-Commit-ID: 9b89f6ba2ab56e4d9c00e7e591d6bc333137895e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 14 Apr 2013 09:09:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b89f6ba2ab56e4d9c00e7e591d6bc333137895e
Gitweb:     http://git.kernel.org/tip/9b89f6ba2ab56e4d9c00e7e591d6bc333137895e
Author:     Andrei Epure <epure.andrei@gmail.com>
AuthorDate: Thu, 11 Apr 2013 20:30:29 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Apr 2013 07:20:27 +0200

sched: Document task_struct::personality field

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1365701429-4721-1-git-send-email-epure.andrei@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9004f6e..6bdaa73 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1105,8 +1105,10 @@ struct task_struct {
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
-	/* ??? */
+
+	/* Used for emulating ABI behavior of previous Linux versions */
 	unsigned int personality;
+
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
