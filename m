Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaANGBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:01:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaANGBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:01:42 -0500
Date: Mon, 13 Jan 2014 22:00:35 -0800
From: tip-bot for Stephen Rothwell <tipbot@zytor.com>
Message-ID: <tip-f549ed1abc7e4f0292ce08c4143c64a610c8b2cb@git.kernel.org>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        sfr@canb.auug.org.au, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20140114164420.d296fbcc4be3a5f126c86069@canb.auug.org.au>
References: <20140114164420.d296fbcc4be3a5f126c86069@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] arch:
  Re-sort some Kbuild files to hopefully help avoid some conflicts
Git-Commit-ID: f549ed1abc7e4f0292ce08c4143c64a610c8b2cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 22:00:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f549ed1abc7e4f0292ce08c4143c64a610c8b2cb
Gitweb:     http://git.kernel.org/tip/f549ed1abc7e4f0292ce08c4143c64a610c8b2cb
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Tue, 14 Jan 2014 16:36:10 +1100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Jan 2014 21:56:54 -0800

arch: Re-sort some Kbuild files to hopefully help avoid some conflicts

Checkin:

    93ea02bb8435 arch: Clean up asm/barrier.h implementations using asm-generic/barrier.h

... unfortunately left some Kbuild files out of order, which caused
unnecessary merge conflicts, in particular with checkin:

    e3fec2f74f7f lib: Add missing arch generic-y entries for asm-generic/hash.h

Put them back in order to make the upcoming merges cleaner.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/20140114164420.d296fbcc4be3a5f126c86069@canb.auug.org.au
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>
---
 arch/arc/include/asm/Kbuild        | 2 +-
 arch/cris/include/asm/Kbuild       | 2 +-
 arch/hexagon/include/asm/Kbuild    | 2 +-
 arch/microblaze/include/asm/Kbuild | 2 +-
 arch/mn10300/include/asm/Kbuild    | 2 +-
 arch/parisc/include/asm/Kbuild     | 2 +-
 arch/score/include/asm/Kbuild      | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index e07c786..9ae21c1 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -1,4 +1,5 @@
 generic-y += auxvec.h
+generic-y += barrier.h
 generic-y += bugs.h
 generic-y += bitsperlong.h
 generic-y += clkdev.h
@@ -47,4 +48,3 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
-generic-y += barrier.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 35ec2e5..199b1a9 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -3,6 +3,7 @@ header-y += arch-v10/
 header-y += arch-v32/
 
 
+generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
@@ -12,4 +13,3 @@ generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
-generic-y += barrier.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index a614ec9..ada843c 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -2,6 +2,7 @@
 header-y += ucontext.h
 
 generic-y += auxvec.h
+generic-y += barrier.h
 generic-y += bug.h
 generic-y += bugs.h
 generic-y += clkdev.h
@@ -54,4 +55,3 @@ generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
 generic-y += preempt.h
-generic-y += barrier.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index f77fb66..a824265 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,7 +1,7 @@
 
+generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += syscalls.h
 generic-y += preempt.h
-generic-y += barrier.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 367ef39..032143e 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,6 +1,6 @@
 
+generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
-generic-y += barrier.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 8df06d0..34b0be4 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,8 +1,8 @@
 
+generic-y += barrier.h
 generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
 	  segment.h topology.h vga.h device.h percpu.h hw_irq.h mutex.h \
 	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
 	  poll.h xor.h clkdev.h exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
-generic-y += barrier.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index ee2993b..fe7471e 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -1,8 +1,8 @@
 
 header-y +=
 
+generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += preempt.h
-generic-y += barrier.h
