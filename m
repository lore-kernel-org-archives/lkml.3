Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaAVM2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:28:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59488 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaAVM23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:28:29 -0500
Date: Wed, 22 Jan 2014 04:27:27 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-981c3a4ff8596a9dcd2b058ee12d6749639c32a5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, alan@linux.intel.com,
        hpa@zytor.com, mingo@kernel.org, joe@perches.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com,
        acme@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] MAINTAINERS: Restore "L:
  linux-kernel@vger.kernel.org" entries
Git-Commit-ID: 981c3a4ff8596a9dcd2b058ee12d6749639c32a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 22 Jan 2014 04:27:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  981c3a4ff8596a9dcd2b058ee12d6749639c32a5
Gitweb:     http://git.kernel.org/tip/981c3a4ff8596a9dcd2b058ee12d6749639c32a5
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 21 Jan 2014 10:59:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 22 Jan 2014 13:25:55 +0100

MAINTAINERS: Restore "L: linux-kernel@vger.kernel.org" entries

A couple of years ago all the "L: lkml" email list entries in
MAINTAINERS were removed and replaced with a 'the rest' entry
at the end of the file - under the theory that this is unnecessary
duplication and that people would find it intuitive:

  b5472cddbe2c MAINTAINERS: remove L: linux-kernel@vger.kernel.org from all but "THE REST"

So it turns out that it's all but intuitive, not all people
use scripts/get_maintainer.pl to extract maintainer contact info,
some people read the MAINTAINERS file and see the lack of 'L:' entries
of various lkml-only subsystems and are sending patches to the
maintainers only, without Cc:-ing lkml.  They arguably have a point.

In hindsight removing all the "L: lkml" entries was probably not
an overly good idea, not all mechanic duplication should be eliminated:
in files read by humans it's useful to have 'at a glance' summary for
all email addresses important to a subsystem's maintenance, in a single
place, without too many imported rules and assumptions.

So, to make the lkml fallback really apparent, add back 'L: lkml'
entries to all subsystem entries whose workflow I'm involved in.
This should at minimum be a per subsystem policy thing.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/n/tip-lhzlymtgmmv5bMuwsb5zyoYo@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ce1645e..e048de5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2191,6 +2191,7 @@ F:	include/linux/clk.h
 CLOCKSOURCE, CLOCKEVENT DRIVERS
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	drivers/clocksource
@@ -3985,6 +3986,7 @@ F:	include/uapi/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Maintained
 F:	Documentation/timers/
@@ -4654,6 +4656,7 @@ F:	net/irda/
 
 IRQ SUBSYSTEM
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 F:	kernel/irq/
@@ -5285,6 +5288,7 @@ F:	drivers/media/usb/dvb-usb-v2/lmedm04*
 LOCKDEP AND LOCKSTAT
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/locking
 S:	Maintained
 F:	Documentation/lockdep*.txt
@@ -6581,6 +6585,7 @@ M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
 F:	kernel/events/*
@@ -6704,6 +6709,7 @@ F:	drivers/scsi/pm8001/
 
 POSIX CLOCKS and TIMERS
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	fs/timerfd.c
@@ -7099,6 +7105,7 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
@@ -7106,6 +7113,7 @@ F:	kernel/rcu/torture.c
 
 RCUTORTURE TEST FRAMEWORK
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	tools/testing/selftests/rcutorture
@@ -7129,6 +7137,7 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
@@ -7432,6 +7441,7 @@ F:	drivers/mmc/host/dw_mmc*
 TIMEKEEPING, CLOCKSOURCE CORE, NTP
 M:	John Stultz <john.stultz@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	include/linux/clocksource.h
@@ -7457,6 +7467,7 @@ F:	drivers/watchdog/sc1200wdt.c
 SCHEDULER
 M:	Ingo Molnar <mingo@redhat.com>
 M:	Peter Zijlstra <peterz@infradead.org>
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
 S:	Maintained
 F:	kernel/sched/
@@ -7823,6 +7834,7 @@ F:	mm/sl?b.c
 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <laijs@cn.fujitsu.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
@@ -9531,6 +9543,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
 M:	Ingo Molnar <mingo@redhat.com>
 M:	"H. Peter Anvin" <hpa@zytor.com>
 M:	x86@kernel.org
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/core
 S:	Maintained
 F:	Documentation/x86/
