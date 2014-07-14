Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaGNPK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:10:28 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48481 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbaGNPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:38 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 38/38] asm-generic: introduc Kbuild.generic
Date: Mon, 14 Jul 2014 17:09:06 +0200
Message-Id: <1405350546-28467-38-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kbuild.generic is for asm-generic files that are used
by all architectures.
So rather than adding the file to the individual Kbuild files
it is enough to add it to this file

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/Kbuild      | 4 ++--
 arch/arc/include/asm/Kbuild        | 4 +++-
 arch/arm/include/asm/Kbuild        | 4 ++--
 arch/arm64/include/asm/Kbuild      | 4 ++--
 arch/avr32/include/asm/Kbuild      | 3 ++-
 arch/blackfin/include/asm/Kbuild   | 3 ++-
 arch/c6x/include/asm/Kbuild        | 3 ++-
 arch/cris/include/asm/Kbuild       | 4 +++-
 arch/frv/include/asm/Kbuild        | 3 ++-
 arch/hexagon/include/asm/Kbuild    | 4 +++-
 arch/ia64/include/asm/Kbuild       | 3 ++-
 arch/m32r/include/asm/Kbuild       | 3 ++-
 arch/m68k/include/asm/Kbuild       | 4 +++-
 arch/metag/include/asm/Kbuild      | 4 +++-
 arch/microblaze/include/asm/Kbuild | 3 ++-
 arch/mips/include/asm/Kbuild       | 5 +++--
 arch/mn10300/include/asm/Kbuild    | 3 ++-
 arch/openrisc/include/asm/Kbuild   | 4 +++-
 arch/parisc/include/asm/Kbuild     | 3 ++-
 arch/powerpc/include/asm/Kbuild    | 3 ++-
 arch/s390/include/asm/Kbuild       | 4 ++--
 arch/score/include/asm/Kbuild      | 3 ++-
 arch/sh/include/asm/Kbuild         | 3 ++-
 arch/sparc/include/asm/Kbuild      | 5 ++---
 arch/tile/include/asm/Kbuild       | 4 +++-
 arch/um/include/asm/Kbuild         | 4 +++-
 arch/unicore32/include/asm/Kbuild  | 3 ++-
 arch/x86/include/asm/Kbuild        | 4 +++-
 arch/xtensa/include/asm/Kbuild     | 4 +++-
 include/asm-generic/Kbuild.generic | 6 ++++++
 30 files changed, 75 insertions(+), 36 deletions(-)
 create mode 100644 include/asm-generic/Kbuild.generic

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 96e54be..e09f8e7 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -1,9 +1,9 @@
-
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index e76fd79..dbbec4e 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += auxvec.h
 generic-y += barrier.h
 generic-y += bitsperlong.h
@@ -22,7 +25,6 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += param.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index f5a3576..a4c11de 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -1,4 +1,5 @@
-
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += auxvec.h
 generic-y += bitsperlong.h
@@ -14,7 +15,6 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += param.h
 generic-y += parport.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 0b3fcf8..af90fa1 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -1,4 +1,5 @@
-
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += bug.h
 generic-y += bugs.h
@@ -24,7 +25,6 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 00a0f3c..11b0832 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,3 +1,5 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += clkdev.h
 generic-y += cputime.h
@@ -11,7 +13,6 @@ generic-y += hash.h
 generic-y += irq_regs.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += param.h
 generic-y += percpu.h
 generic-y += preempt.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index 0d93b9a..6cd2c8a 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -1,3 +1,5 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += auxvec.h
 generic-y += bitsperlong.h
@@ -20,7 +22,6 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 8dbdce8..1dbe688 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -1,3 +1,5 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += atomic.h
 generic-y += auxvec.h
@@ -25,7 +27,6 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += mmu.h
 generic-y += mmu_context.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 35574f5..b286b91 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
@@ -5,7 +8,6 @@ generic-y += exec.h
 generic-y += hash.h
 generic-y += kvm_para.h
 generic-y += linkage.h
-generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 87b95eb..e09f8e7 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -1,8 +1,9 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 1ddcd97..989b82a 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += auxvec.h
 generic-y += barrier.h
 generic-y += bug.h
@@ -24,7 +27,6 @@ generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += pci.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 0da4aa2..9c100e5 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -1,9 +1,10 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += kvm_para.h
-generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += vtime.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 67779a7..57c22c3 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,9 +1,10 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index c67c94a..20b69ab 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += barrier.h
 generic-y += bitsperlong.h
 generic-y += clkdev.h
@@ -16,7 +19,6 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += mutex.h
 generic-y += percpu.h
diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
index c29ead8..40c08fb 100644
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += auxvec.h
 generic-y += bitsperlong.h
 generic-y += bugs.h
@@ -24,7 +27,6 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 35b3eca..0173da4 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,3 +1,5 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += barrier.h
 generic-y += clkdev.h
@@ -5,7 +7,6 @@ generic-y += cputime.h
 generic-y += device.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += syscalls.h
 generic-y += trace_clock.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 0543918..e7a6309 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -1,10 +1,11 @@
-# MIPS headers
+# Generic wrappers from include/asm-generic for MIPS
+include include/asm-generic/Kbuild.generic
+
 generic-y += cputime.h
 generic-y += current.h
 generic-y += emergency-restart.h
 generic-y += hash.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += mutex.h
 generic-y += parport.h
 generic-y += percpu.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 654d5ba..0acedc8 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,9 +1,10 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 4a80261..3bd2ea3 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += atomic.h
 generic-y += auxvec.h
 generic-y += barrier.h
@@ -32,7 +35,6 @@ generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index ecf25e6..db2ae76 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,3 +1,5 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += auxvec.h
 generic-y += barrier.h
@@ -14,7 +16,6 @@ generic-y += kdebug.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += mutex.h
 generic-y += param.h
 generic-y += percpu.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 3fb1bc4..16d1cbd 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -1,7 +1,8 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += clkdev.h
 generic-y += hash.h
-generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += rwsem.h
 generic-y += trace_clock.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 57892a8..e601c95 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -1,7 +1,7 @@
-
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += clkdev.h
 generic-y += hash.h
-generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index f67b3f6..79b3095 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -1,9 +1,10 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += hash.h
-generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += xor.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index c19e47d..bef0d46 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -1,3 +1,5 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += bitsperlong.h
 generic-y += cputime.h
@@ -15,7 +17,6 @@ generic-y += irq_regs.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += param.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index a458218..3b2f282 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -1,5 +1,5 @@
-# User exported sparc header files
-
+# Generic wrappers from include/asm-generic for sparc
+include include/asm-generic/Kbuild.generic
 
 generic-y += clkdev.h
 generic-y += cputime.h
@@ -11,7 +11,6 @@ generic-y += irq_regs.h
 generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += mutex.h
 generic-y += preempt.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 3013a07..19ba1b8 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += bug.h
 generic-y += bugs.h
 generic-y += clkdev.h
@@ -16,7 +19,6 @@ generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index a5e4b60..1c065c3 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += barrier.h
 generic-y += bug.h
 generic-y += clkdev.h
@@ -15,7 +18,6 @@ generic-y += hw_irq.h
 generic-y += io.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
-generic-y += mcs_spinlock.h
 generic-y += mutex.h
 generic-y += param.h
 generic-y += pci.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index 1e5fb87..f64e1ba 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -1,3 +1,5 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
 
 generic-y += atomic.h
 generic-y += auxvec.h
@@ -25,7 +27,6 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
-generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 3221167..2c03169 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -1,4 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += clkdev.h
 generic-y += early_ioremap.h
 generic-y += cputime.h
-generic-y += mcs_spinlock.h
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index c3d20ba..a2cc705 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -1,3 +1,6 @@
+# Generic wrappers from include/asm-generic
+include include/asm-generic/Kbuild.generic
+
 generic-y += bitsperlong.h
 generic-y += bug.h
 generic-y += clkdev.h
@@ -18,7 +21,6 @@ generic-y += kvm_para.h
 generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
-generic-y += mcs_spinlock.h
 generic-y += percpu.h
 generic-y += preempt.h
 generic-y += resource.h
diff --git a/include/asm-generic/Kbuild.generic b/include/asm-generic/Kbuild.generic
new file mode 100644
index 0000000..f44815b
--- /dev/null
+++ b/include/asm-generic/Kbuild.generic
@@ -0,0 +1,6 @@
+# List of generic header files that is used by all architectures
+# This file is included by arch/*/include/asm/Kbuild
+#
+# Keep the list sorted alphabetically
+
+generic-y += mcs_spinlock.h
-- 
1.9.3

