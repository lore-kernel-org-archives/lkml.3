Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaG1FS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:18:57 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:11209 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaG1FSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:18:54 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip/master 3/7] locking/mcs: Remove obsolete comment
Date: Sun, 27 Jul 2014 22:18:40 -0700
Message-Id: <1406524724-17946-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... as we clearly inline mcs_spin_lock() now.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
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
-- 
1.8.1.4

