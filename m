Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3CTXep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:34:45 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:64153 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3CTXek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:34:40 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 3/3] ARM: Kconfig: allow virt CPU accounting
Date: Wed, 20 Mar 2013 16:34:27 -0700
Message-Id: <1363822467-6275-4-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1363822467-6275-1-git-send-email-khilman@linaro.org>
References: <1363822467-6275-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 64-bit requirement removed from virt CPU accounting,
allow ARM platforms to enable it.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b71469..9473d55 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -59,6 +59,7 @@ config ARM
 	select CLONE_BACKWARDS
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select HAVE_VIRT_CPU_ACCOUNTING
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
-- 
1.8.2

