Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3JSUYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 16:24:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33022 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103Ab3JSUYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 16:24:15 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] x86: remove duplicate includes
Date: Sat, 19 Oct 2013 22:24:03 +0200
Message-Id: <1382214243-8846-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by running "make includecheck"

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 1 -
 arch/x86/kernel/smpboot.c             | 2 --
 arch/x86/platform/ce4100/ce4100.c     | 1 -
 3 files changed, 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1414c90..b5f5dbc 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -903,7 +903,6 @@ static int detect_cache_attributes(unsigned int cpu)
 
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
-#include <linux/cpu.h>
 
 /* pointer to kobject for cpuX/cache */
 static DEFINE_PER_CPU(struct kobject *, ici_cache_kobject);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6cacab6..f4a3ae1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -77,8 +77,6 @@
 #include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 
-#include <asm/realmode.h>
-
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 8244f5e..d62e74d 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -15,7 +15,6 @@
 #include <linux/reboot.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
-#include <linux/reboot.h>
 
 #include <asm/ce4100.h>
 #include <asm/prom.h>
-- 
1.8.1.2

