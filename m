Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3J3Nke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:40:34 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42381 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3J3Nkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:40:33 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] arm: remove duplicate includes
Date: Wed, 30 Oct 2013 19:02:19 +0530
Message-Id: <1383139939-26387-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.1.559.gdb9bdfb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As spotted by scripts/checkincludes.pl.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 arch/arm/kvm/handle_exit.c            | 2 --
 arch/arm/mach-lpc32xx/phy3250.c       | 1 -
 arch/arm/mach-omap1/board-voiceblue.c | 1 -
 arch/arm/mach-sa1100/hackkit.c        | 1 -
 arch/arm/mach-vexpress/v2m.c          | 1 -
 5 files changed, 6 deletions(-)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index df4c82d..0366438 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -26,8 +26,6 @@
 
 #include "trace.h"
 
-#include "trace.h"
-
 typedef int (*exit_handle_fn)(struct kvm_vcpu *, struct kvm_run *);
 
 static int handle_svc_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index e54f87e..917ef29 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -23,7 +23,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/dma-mapping.h>
-#include <linux/device.h>
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/clcd.h>
diff --git a/arch/arm/mach-omap1/board-voiceblue.c b/arch/arm/mach-omap1/board-voiceblue.c
index 4677a9c..4b382a0 100644
--- a/arch/arm/mach-omap1/board-voiceblue.c
+++ b/arch/arm/mach-omap1/board-voiceblue.c
@@ -26,7 +26,6 @@
 #include <linux/serial_reg.h>
 #include <linux/smc91x.h>
 #include <linux/export.h>
-#include <linux/reboot.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-sa1100/hackkit.c b/arch/arm/mach-sa1100/hackkit.c
index 643d5f2..0016d25 100644
--- a/arch/arm/mach-sa1100/hackkit.c
+++ b/arch/arm/mach-sa1100/hackkit.c
@@ -22,7 +22,6 @@
 #include <linux/serial_core.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
-#include <linux/tty.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/platform_device.h>
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 95a469e..9f0eea6 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -6,7 +6,6 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
-#include <linux/clocksource.h>
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/of_address.h>
-- 
1.8.4.1.559.gdb9bdfb

