Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3BVBgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:36:19 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:59289 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3BVBgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:36:18 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/2] irq: Cleanups in irq_exit()
Date: Fri, 22 Feb 2013 02:36:09 +0100
Message-Id: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Those are based on tip:/irq/urgent. I'm pretty confident about the
1st patch. The 2nd patch passed through some discussions with Thomas:
it's a nice cleanup but it involves a small unfortunate workaround,
so I tagged it as an RFC. I have mixed feelings about it.

Thanks.

Frederic Weisbecker (2):
  irq: Remove IRQ_EXIT_OFFSET workaround
  irq: Cleanup context state transitions in irq_exit()

 include/linux/hardirq.h |    3 +-
 kernel/softirq.c        |   53 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 11 deletions(-)

-- 
1.7.5.4

