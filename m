Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaJUOMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:12:55 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47624 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874AbaJUOMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:12:50 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: rmk+kernel@arm.linux.org.uk, arm@kernel.org
Cc: kaixu.xia@linaro.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/4] ARM: change the corresponding arm/mach defconfigs
Date: Tue, 21 Oct 2014 22:11:32 +0800
Message-Id: <1413900694-29571-3-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413900694-29571-1-git-send-email-kaixu.xia@linaro.org>
References: <1413900694-29571-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DEBUG_LL will get a dependency on !ARCH_MULTIPLATFORM_STRICT.
So change the corresponding arm/mach defconfigs to disable 
ARCH_MULTIPLATFORM_STRICT and avoid break them.

Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
---
 arch/arm/configs/bcm2835_defconfig | 1 +
 arch/arm/configs/moxart_defconfig  | 1 +
 arch/arm/configs/s5pv210_defconfig | 1 +
 arch/arm/configs/tegra_defconfig   | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index 31cb073..e644c8b 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -135,6 +135,7 @@ CONFIG_TEST_KSTRTOX=y
 CONFIG_KGDB=y
 CONFIG_KGDB_KDB=y
 CONFIG_STRICT_DEVMEM=y
+# CONFIG_ARCH_MULTIPLATFORM_STRICT is not set
 CONFIG_DEBUG_LL=y
 CONFIG_EARLY_PRINTK=y
 # CONFIG_XZ_DEC_ARM is not set
diff --git a/arch/arm/configs/moxart_defconfig b/arch/arm/configs/moxart_defconfig
index a3cb76c..7ba9343 100644
--- a/arch/arm/configs/moxart_defconfig
+++ b/arch/arm/configs/moxart_defconfig
@@ -140,6 +140,7 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_DMA_API_DEBUG=y
 CONFIG_KGDB=y
+# CONFIG_ARCH_MULTIPLATFORM_STRICT is not set
 CONFIG_DEBUG_LL=y
 CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_DEBUG_UART_PHYS=0x98200000
diff --git a/arch/arm/configs/s5pv210_defconfig b/arch/arm/configs/s5pv210_defconfig
index fa98990..bc0cad4 100644
--- a/arch/arm/configs/s5pv210_defconfig
+++ b/arch/arm/configs/s5pv210_defconfig
@@ -67,6 +67,7 @@ CONFIG_DEBUG_INFO=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
+# CONFIG_ARCH_MULTIPLATFORM_STRICT is not set
 CONFIG_DEBUG_LL=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_DEBUG_S3C_UART=1
diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 888fc15..851b80b 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -291,6 +291,7 @@ CONFIG_TIMER_STATS=y
 # CONFIG_DEBUG_PREEMPT is not set
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_SG=y
+# CONFIG_ARCH_MULTIPLATFORM_STRICT is not set
 CONFIG_DEBUG_LL=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_CRYPTO_TWOFISH=y
-- 
2.1.1

