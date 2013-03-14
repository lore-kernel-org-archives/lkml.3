Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3CNO0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:26:38 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:64001 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3CNO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:26:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Hogan <james.hogan@imgtec.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [GIT PULL] printk: fixes
Date: Thu, 14 Mar 2013 15:26:27 +0100
Message-Id: <1363271189-6631-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the following printk regression fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	printk/urgent

HEAD: c45a372bdfc0115147afb7eea11313dc057c817e

Thanks.

---
Frederic Weisbecker (1):
  printk: Provide a wake_up_klogd() off-case

James Hogan (1):
  irq_work.h: fix warning when CONFIG_IRQ_WORK=n

 include/linux/irq_work.h |    2 +-
 include/linux/kernel.h   |    1 -
 include/linux/printk.h   |    6 +++
 kernel/printk.c          |   80 ++++++++++++++++++++++-----------------------
 4 files changed, 46 insertions(+), 43 deletions(-)

-- 
1.7.5.4

