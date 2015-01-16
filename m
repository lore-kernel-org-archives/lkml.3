Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbbAPInr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:43:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbbAPInq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:43:46 -0500
Date: Fri, 16 Jan 2015 00:43:11 -0800
From: tip-bot for SeongJae Park <tipbot@zytor.com>
Message-ID: <tip-a97af339c80675402d23923f9514491e0a6b5477@git.kernel.org>
Cc: sj38.park@gmail.com, peterz@infradead.org, torvalds@linux-foundation.org,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de, corbet@lwn.net,
        linux-kernel@vger.kernel.org
Reply-To: peterz@infradead.org, sj38.park@gmail.com,
        torvalds@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net
In-Reply-To: <1421176921-27688-1-git-send-email-sj38.park@gmail.com>
References: <1421176921-27688-1-git-send-email-sj38.park@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/Documentation: Update code path
Git-Commit-ID: a97af339c80675402d23923f9514491e0a6b5477
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

Commit-ID:  a97af339c80675402d23923f9514491e0a6b5477
Gitweb:     http://git.kernel.org/tip/a97af339c80675402d23923f9514491e0a6b5477
Author:     SeongJae Park <sj38.park@gmail.com>
AuthorDate: Wed, 14 Jan 2015 04:22:01 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Jan 2015 09:09:21 +0100

locking/Documentation: Update code path

lockdep code has been moved from kernel/ to kernel/locking/ by commit
8eddac3f103736163f49255bcb109edadea167f6 ("locking: Move the lockdep
code to kernel/locking/"). But, path to lockdep code in document was not
updated.

This commit updates the path.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1421176921-27688-1-git-send-email-sj38.park@gmail.com
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/locking/lockdep-design.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/locking/lockdep-design.txt b/Documentation/locking/lockdep-design.txt
index 5dbc99c..5001280 100644
--- a/Documentation/locking/lockdep-design.txt
+++ b/Documentation/locking/lockdep-design.txt
@@ -34,7 +34,7 @@ The validator tracks lock-class usage history into 4n + 1 separate state bits:
 - 'ever held with STATE enabled'
 - 'ever held as readlock with STATE enabled'
 
-Where STATE can be either one of (kernel/lockdep_states.h)
+Where STATE can be either one of (kernel/locking/lockdep_states.h)
  - hardirq
  - softirq
  - reclaim_fs
