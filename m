Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbaLOCYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:24:46 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49496 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaLOCYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:24:39 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/2] sched: Preemption fixlet and cleanup
Date: Mon, 15 Dec 2014 03:24:30 +0100
Message-Id: <1418610272-21518-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the reworked fix against the missing preemption check that Linus
reported + the need_resched() loop pulled up to __schedule() callers also
suggested by him.

Thanks.

Frederic Weisbecker (2):
  sched: Fix missing preemption check in cond_resched()
  sched: Pull resched loop to __schedule() callers

 kernel/sched/core.c | 51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

-- 
2.1.3

