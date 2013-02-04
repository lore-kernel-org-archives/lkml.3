Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3BDSJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:09:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36251 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3BDSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:09:46 -0500
Date: Mon, 4 Feb 2013 10:08:13 -0800
From: tip-bot for James Hogan <james.hogan@imgtec.com>
Message-ID: <tip-f7c819c020db9796ae3a662b82a310617f92b15b@git.kernel.org>
Cc: mingo@kernel.org, linuxppc-dev@lists.ozlabs.org, tony.luck@intel.com,
        linux-mips@linux-mips.org, ralf@linux-mips.org, vapier@gentoo.org,
        tglx@linutronix.de, deller@gmx.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, paulus@samba.org, james.hogan@imgtec.com,
        lethal@linux-sh.org, benh@kernel.crashing.org, fenghua.yu@intel.com,
        jejb@parisc-linux.org, uclinux-dist-devel@blackfin.uclinux.org,
        rkuo@codeaurora.org
Reply-To: mingo@kernel.org, linuxppc-dev@lists.ozlabs.org, tony.luck@intel.com,
        linux-mips@linux-mips.org, ralf@linux-mips.org, vapier@gentoo.org,
        tglx@linutronix.de, deller@gmx.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, paulus@samba.org, james.hogan@imgtec.com,
        lethal@linux-sh.org, benh@kernel.crashing.org, fenghua.yu@intel.com,
        jejb@parisc-linux.org, uclinux-dist-devel@blackfin.uclinux.org,
        rkuo@codeaurora.org
In-Reply-To: <1359972583-17134-1-git-send-email-james.hogan@imgtec.com>
References: <1359972583-17134-1-git-send-email-james.hogan@imgtec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] arch Kconfig: Remove references to IRQ_PER_CPU
Git-Commit-ID: f7c819c020db9796ae3a662b82a310617f92b15b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 10:08:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7c819c020db9796ae3a662b82a310617f92b15b
Gitweb:     http://git.kernel.org/tip/f7c819c020db9796ae3a662b82a310617f92b15b
Author:     James Hogan <james.hogan@imgtec.com>
AuthorDate: Mon, 4 Feb 2013 10:09:43 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Feb 2013 18:53:20 +0100

arch Kconfig: Remove references to IRQ_PER_CPU

The IRQ_PER_CPU Kconfig symbol was removed in the following commit:

Commit 6a58fb3bad099076f36f0f30f44507bc3275cdb6 ("genirq: Remove
CONFIG_IRQ_PER_CPU") merged in v2.6.39-rc1.

But IRQ_PER_CPU wasn't removed from any of the architecture Kconfig
files where it was defined or selected. It's completely unused so remove
the remaining references.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: <uclinux-dist-devel@blackfin.uclinux.org>
Cc: <linux-mips@linux-mips.org>
Cc: <linuxppc-dev@lists.ozlabs.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Tony Luck <tony.luck@intel.com>
Acked-by: Richard Kuo <rkuo@codeaurora.org>
Link: http://lkml.kernel.org/r/1359972583-17134-1-git-send-email-james.hogan@imgtec.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/blackfin/Kconfig | 1 -
 arch/hexagon/Kconfig  | 1 -
 arch/ia64/Kconfig     | 1 -
 arch/mips/Kconfig     | 1 -
 arch/parisc/Kconfig   | 1 -
 arch/powerpc/Kconfig  | 1 -
 arch/sh/Kconfig       | 3 ---
 7 files changed, 9 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 86f891f..67e4aaa 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -37,7 +37,6 @@ config BLACKFIN
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_PROBE
-	select IRQ_PER_CPU if SMP
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 40a3185..e4decc6 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -12,7 +12,6 @@ config HEXAGON
 	# select ARCH_WANT_OPTIONAL_GPIOLIB
 	# select ARCH_REQUIRE_GPIOLIB
 	# select HAVE_CLK
-	# select IRQ_PER_CPU
 	# select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 3279646..00c2e88 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -29,7 +29,6 @@ config IA64
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
-	select IRQ_PER_CPU
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 121ed51..9becc44 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2160,7 +2160,6 @@ source "mm/Kconfig"
 config SMP
 	bool "Multi-Processing support"
 	depends on SYS_SUPPORTS_SMP
-	select IRQ_PER_CPU
 	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 9dd5c18..a32e34e 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -15,7 +15,6 @@ config PARISC
 	select BROKEN_RODATA
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PCI_IOMAP
-	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d45edca..561ccca 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -124,7 +124,6 @@ config PPC
 	select HAVE_GENERIC_HARDIRQS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select SPARSE_IRQ
-	select IRQ_PER_CPU
 	select IRQ_DOMAIN
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 996e008..9c833c5 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -90,9 +90,6 @@ config GENERIC_CSUM
 config GENERIC_HWEIGHT
 	def_bool y
 
-config IRQ_PER_CPU
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool n
 
