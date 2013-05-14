Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab3ENQDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:03:03 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:57206 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3ENQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:03:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] Nohz fixes
Date: Tue, 14 May 2013 18:02:50 +0200
Message-Id: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/urgent

Thanks,
	Frederic
---

Steven Rostedt (2):
      nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is enabled
      nohz: Warn if the machine can not perform nohz_full


 kernel/time/tick-sched.c |    5 +++++
 lib/Kconfig.debug        |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)
