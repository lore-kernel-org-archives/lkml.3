Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3B1UC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:02:56 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:40669 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3B1UCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:02:55 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [GIT PULL] irq: cleanups
Date: Thu, 28 Feb 2013 21:02:45 +0100
Message-Id: <1362081767-30684-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Until everyone agrees on https://patchwork.kernel.org/patch/2174211/ ,
here are two commits that seem quite uncontroversial to me.

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	irq/urgent-for-tip

Thanks.

Frederic Weisbecker (2):
  irq: Remove IRQ_EXIT_OFFSET workaround
  irq: Don't re-enable interrupts at the end of irq_exit

 include/linux/hardirq.h |    2 --
 kernel/softirq.c        |   10 ++--------
 2 files changed, 2 insertions(+), 10 deletions(-)

-- 
1.7.5.4

