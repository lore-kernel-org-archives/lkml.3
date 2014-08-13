Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaHMK4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:56:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHMK4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:56:16 -0400
Date: Wed, 13 Aug 2014 03:55:19 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-aa9fc0c19bee0cbc152e0e06488095fb69229236@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1406752916-3341-3-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-3-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mcs: Remove obsolete comment
Git-Commit-ID: aa9fc0c19bee0cbc152e0e06488095fb69229236
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa9fc0c19bee0cbc152e0e06488095fb69229236
Gitweb:     http://git.kernel.org/tip/aa9fc0c19bee0cbc152e0e06488095fb69229236
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Wed, 30 Jul 2014 13:41:52 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:32:00 +0200

locking/mcs: Remove obsolete comment

... as we clearly inline mcs_spin_lock() now.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: aswin@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1406752916-3341-3-git-send-email-davidlohr@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mcs_spinlock.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index 23e89c5..4d60986 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -56,9 +56,6 @@ do {									\
  * If the lock has already been acquired, then this will proceed to spin
  * on this node->locked until the previous lock holder sets the node->locked
  * in mcs_spin_unlock().
- *
- * We don't inline mcs_spin_lock() so that perf can correctly account for the
- * time spent in this lock function.
  */
 static inline
 void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
