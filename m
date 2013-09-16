Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3IPW2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:28:37 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34596 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3IPW2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:28:30 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] nohz_full: Kconfig: drop requrement on 64-bit
Date: Mon, 16 Sep 2013 15:28:20 -0700
Message-Id: <1379370502-30376-3-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1379370502-30376-1-git-send-email-khilman@linaro.org>
References: <1379370502-30376-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that VIRT_CPU_ACCOUNTING_GEN no longer has a 64-bit requirement,
it can be dropped here as well.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 kernel/time/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 2b62fe8..a54e3e9 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -99,8 +99,6 @@ config NO_HZ_FULL
 	depends on SMP
 	# RCU_USER_QS dependency
 	depends on HAVE_CONTEXT_TRACKING
-	# VIRT_CPU_ACCOUNTING_GEN dependency
-	depends on 64BIT
 	select NO_HZ_COMMON
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
-- 
1.8.3

