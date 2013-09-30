Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3I3OHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:07:13 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38036 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3I3OHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:07:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arm Linux <linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] ARM: Kconfig: allow full nohz CPU accounting
Date: Mon, 30 Sep 2013 16:06:52 +0200
Message-Id: <1380550012-7321-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
References: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@linaro.org>

With the 64-bit requirement removed from VIRT_CPU_ACCOUNTING_GEN,
allow ARM platforms to enable it.  Since VIRT_CPU_ACCOUNTING_GEN is a
dependency for full NO_HZ, this allows ARM platforms to enable full
NO_HZ as well.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Arm Linux <linux-arm-kernel@lists.infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6..323baf0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -54,6 +54,7 @@ config ARM
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
+	select HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select IRQ_FORCED_THREADING
 	select KTIME_SCALAR
 	select MODULES_USE_ELF_REL
-- 
1.8.3.1

