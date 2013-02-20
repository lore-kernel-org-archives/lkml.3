Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026Ab3BTTly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:41:54 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35443 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934450Ab3BTTlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:41:52 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Subject: [RFC/PATCH 3/5] virt CPU accounting: Kconfig: drop 64-bit requirment
Date: Wed, 20 Feb 2013 11:41:40 -0800
Message-Id: <1361389302-11968-4-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361389302-11968-1-git-send-email-khilman@linaro.org>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit requirement can be removed after the conversion of
kernel_cpustat accessors to the portable atomic64 accessors.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 3abb019..b13af06 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -356,7 +356,7 @@ config VIRT_CPU_ACCOUNTING_NATIVE
 
 config VIRT_CPU_ACCOUNTING_GEN
 	bool "Full dynticks CPU time accounting"
-	depends on HAVE_CONTEXT_TRACKING && 64BIT
+	depends on HAVE_CONTEXT_TRACKING
 	select VIRT_CPU_ACCOUNTING
 	select CONTEXT_TRACKING
 	help
-- 
1.8.1.2

