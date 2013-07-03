Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab3GCSg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:36:56 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57462 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab3GCSgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:36:53 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 3/3] ARM: Kconfig: allow virt CPU accounting
Date: Wed,  3 Jul 2013 11:36:41 -0700
Message-Id: <1372876601-23881-4-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1372876601-23881-1-git-send-email-khilman@linaro.org>
References: <1372876601-23881-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 64-bit requirement removed from virt CPU accounting,
allow ARM platforms to enable it.

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 136f263..7850612 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -61,6 +61,7 @@ config ARM
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
 	select HAVE_CONTEXT_TRACKING
+	select HAVE_VIRT_CPU_ACCOUNTING
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
-- 
1.8.3

