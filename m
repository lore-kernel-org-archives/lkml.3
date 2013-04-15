Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094Ab3DOVKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:10:35 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45747 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628Ab3DOVKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:10:33 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] nohz: Align periodic tick Kconfig with other choices' naming convention
Date: Mon, 15 Apr 2013 23:10:18 +0200
Message-Id: <1366060220-20271-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
References: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CONFIG_PERIODIC_HZ to CONFIG_HZ_PERIODIC in
order to stay consistent with other tick implementation
entries:

	CONFIG_HZ_PERIODIC
	CONFIG_NO_HZ_IDLE
	CONFIG_NO_HZ_FULL

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 4a17b50..3b68322 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -79,7 +79,7 @@ choice
 	prompt "Timer tick handling"
 	default NO_HZ_IDLE if NO_HZ
 
-config PERIODIC_HZ
+config HZ_PERIODIC
 	bool "Periodic timer ticks (constant rate, no dynticks)"
 	help
 	  This option keeps the tick running periodically at a constant
-- 
1.7.5.4

