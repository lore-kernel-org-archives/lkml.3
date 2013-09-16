Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3IPW2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:28:51 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38626 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3IPW2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:28:35 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: Kconfig: allow full nohz CPU accounting
Date: Mon, 16 Sep 2013 15:28:22 -0700
Message-Id: <1379370502-30376-5-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1379370502-30376-1-git-send-email-khilman@linaro.org>
References: <1379370502-30376-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 64-bit requirement removed from VIRT_CPU_ACCOUNTING_GEN,
allow ARM platforms to enable it.  Since VIRT_CPU_ACCOUNTING_GEN is a
dependency for full NO_HZ, this allows ARM platforms to enable full
NO_HZ as well.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3f7714d..b5e5712 100644
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
1.8.3

