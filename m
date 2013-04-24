Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3DXOpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:45:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49682 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab3DXOpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:45:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] nohz: Fixlet and Kconfig cleanup
Date: Wed, 24 Apr 2013 16:44:56 +0200
Message-Id: <1366814698-8260-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest nohz branch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz

HEAD: 65e709dc0c25dbd563861924815e9a3a93878b75

Thanks.

---
Frederic Weisbecker (2):
  nohz: Fix unavailable tick_stop tracepoint in dynticks idle
  nohz: Remove full dynticks' superfluous dependency on RCU tree

 include/trace/events/timer.h |    2 +-
 kernel/time/Kconfig          |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

-- 
1.7.5.4

