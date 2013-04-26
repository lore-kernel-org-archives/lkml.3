Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3DZOxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:53:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50189 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3DZOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:53:33 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] nohz: A few improvements
Date: Fri, 26 Apr 2013 16:53:25 +0200
Message-Id: <1366988007-30665-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/nohz branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz

Changes:

* Get rid of the passive dependency on VIRT_CPU_ACCOUNTING_GEN (finally!)
* Preparation patch to remove the dependency on CONFIG_64BITS

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      nohz: Select VIRT_CPU_ACCOUNTING_GEN from full dynticks config

Kevin Hilman (1):
      cputime_nsecs: use math64.h for nsec resolution conversion helpers


 include/asm-generic/cputime_nsecs.h |   28 +++++++++++++++++++---------
 init/Kconfig                        |    8 ++++----
 kernel/time/Kconfig                 |    4 +++-
 3 files changed, 26 insertions(+), 14 deletions(-)
