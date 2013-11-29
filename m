Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3K2Ooa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:44:30 -0500
Received: from multi.imgtec.com ([194.200.65.239]:50500 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab3K2Oo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:44:27 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] arch: include/asm/Kbuild: fix preempt.h sort order
Date: Fri, 29 Nov 2013 14:43:11 +0000
Message-ID: <1385736191-31862-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_29_14_44_22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a787870924db (sched, arch: Create asm/preempt.h) added the
generic asm/preempt.h header, but took no notice of the sort order of
various architecture's include/asm/Kbuild files. Move preempt.h into the
correct sort position in files which are mostly already sorted.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/Kbuild     | 2 +-
 arch/arc/include/asm/Kbuild       | 2 +-
 arch/arm/include/asm/Kbuild       | 2 +-
 arch/arm64/include/asm/Kbuild     | 2 +-
 arch/avr32/include/asm/Kbuild     | 2 +-
 arch/blackfin/include/asm/Kbuild  | 2 +-
 arch/c6x/include/asm/Kbuild       | 2 +-
 arch/cris/include/asm/Kbuild      | 2 +-
 arch/frv/include/asm/Kbuild       | 2 +-
 arch/hexagon/include/asm/Kbuild   | 2 +-
 arch/ia64/include/asm/Kbuild      | 4 ++--
 arch/m32r/include/asm/Kbuild      | 2 +-
 arch/m68k/include/asm/Kbuild      | 2 +-
 arch/metag/include/asm/Kbuild     | 2 +-
 arch/mips/include/asm/Kbuild      | 2 +-
 arch/mn10300/include/asm/Kbuild   | 2 +-
 arch/openrisc/include/asm/Kbuild  | 2 +-
 arch/powerpc/include/asm/Kbuild   | 4 ++--
 arch/s390/include/asm/Kbuild      | 2 +-
 arch/score/include/asm/Kbuild     | 2 +-
 arch/sh/include/asm/Kbuild        | 2 +-
 arch/sparc/include/asm/Kbuild     | 2 +-
 arch/tile/include/asm/Kbuild      | 2 +-
 arch/unicore32/include/asm/Kbuild | 2 +-
 arch/xtensa/include/asm/Kbuild    | 2 +-
 25 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index f01fb505ad52..ced11417c940 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -2,5 +2,5 @@
 generic-y += clkdev.h
 
 generic-y += exec.h
-generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 5943f7f9d325..bf7883fe99ae 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -28,6 +28,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sembuf.h
@@ -46,4 +47,3 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index c38b58c80202..8f370768b65f 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -17,6 +17,7 @@ generic-y += msgbuf.h
 generic-y += param.h
 generic-y += parport.h
 generic-y += poll.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += sections.h
 generic-y += segment.h
@@ -33,4 +34,3 @@ generic-y += termios.h
 generic-y += timex.h
 generic-y += trace_clock.h
 generic-y += unaligned.h
-generic-y += preempt.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 519f89f5b6a3..ae33b8eb247a 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -29,6 +29,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -50,4 +51,3 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 658001b52400..b0dc00d98be8 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -7,12 +7,12 @@ generic-y       += div64.h
 generic-y       += emergency-restart.h
 generic-y	+= exec.h
 generic-y       += futex.h
-generic-y	+= preempt.h
 generic-y       += irq_regs.h
 generic-y	+= param.h
 generic-y       += local.h
 generic-y       += local64.h
 generic-y       += percpu.h
+generic-y	+= preempt.h
 generic-y       += scatterlist.h
 generic-y       += sections.h
 generic-y       += topology.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index f2b43474b0e2..2469ae824882 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += mutex.h
 generic-y += param.h
 generic-y += percpu.h
 generic-y += pgalloc.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sembuf.h
@@ -44,4 +45,3 @@ generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += user.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index fc0b3c356027..4b3f516908bd 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -34,6 +34,7 @@ generic-y += percpu.h
 generic-y += pgalloc.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += segment.h
@@ -56,4 +57,3 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index b06caf649a95..0daf19e311f6 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -8,7 +8,7 @@ generic-y += exec.h
 generic-y += kvm_para.h
 generic-y += linkage.h
 generic-y += module.h
+generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 74742dc6a3da..695246ecd32a 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -1,5 +1,5 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
-generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 67c3450309b7..9b85030a3c46 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -31,6 +31,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += rwsem.h
 generic-y += scatterlist.h
@@ -53,4 +54,3 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index f93ee087e8fe..6f1de3b86a51 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -2,6 +2,6 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
-generic-y += trace_clock.h
 generic-y += preempt.h
-generic-y += vtime.h
\ No newline at end of file
+generic-y += trace_clock.h
+generic-y += vtime.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 2b58c5f0bc38..5cfbdd4b23f2 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -2,5 +2,5 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
-generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index a5d27f272a59..f94ad6b0f772 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -18,6 +18,7 @@ generic-y += local.h
 generic-y += mman.h
 generic-y += mutex.h
 generic-y += percpu.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -31,4 +32,3 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
index 84d0c1d6b9b3..3fc4a2ea58b3 100644
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -30,6 +30,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += sembuf.h
@@ -52,4 +53,3 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 1acbb8b77a71..ef38961c3af5 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -6,11 +6,11 @@ generic-y += local64.h
 generic-y += mutex.h
 generic-y += parport.h
 generic-y += percpu.h
+generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += serial.h
 generic-y += trace_clock.h
-generic-y += preempt.h
 generic-y += ucontext.h
 generic-y += xor.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 74742dc6a3da..695246ecd32a 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,5 +1,5 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
-generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index da1951a22907..135e80b5398d 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -41,6 +41,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -68,4 +69,3 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index d8f9d2f18a23..8b19a80d429f 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -1,6 +1,6 @@
 
 generic-y += clkdev.h
+generic-y += preempt.h
 generic-y += rwsem.h
 generic-y += trace_clock.h
-generic-y += preempt.h
-generic-y += vtime.h
\ No newline at end of file
+generic-y += vtime.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 7a5288f3479a..6bd5f27ca7eb 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -1,5 +1,5 @@
 
 
 generic-y += clkdev.h
-generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index f3414ade77a3..966199af2c50 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -2,6 +2,6 @@
 header-y +=
 
 generic-y += clkdev.h
+generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 231efbb68108..c4ac1e36ca29 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -20,6 +20,7 @@ generic-y += percpu.h
 generic-y += poll.h
 generic-y += mman.h
 generic-y += msgbuf.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sembuf.h
@@ -34,4 +35,3 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += ucontext.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index bf390667657a..30140d938cfe 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -12,8 +12,8 @@ generic-y += mutex.h
 generic-y += irq_regs.h
 generic-y += local.h
 generic-y += module.h
+generic-y += preempt.h
 generic-y += serial.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
-generic-y += preempt.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 22f3bd147fa7..948549c78d67 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -24,6 +24,7 @@ generic-y += param.h
 generic-y += parport.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sembuf.h
@@ -38,4 +39,3 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index 00045cbe5c63..a61f73a15166 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -32,6 +32,7 @@ generic-y += parport.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -60,4 +61,3 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 228d6aee3a16..68da9d495c94 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -19,6 +19,7 @@ generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += percpu.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -28,4 +29,3 @@ generic-y += termios.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += xor.h
-generic-y += preempt.h
-- 
1.8.1.2


