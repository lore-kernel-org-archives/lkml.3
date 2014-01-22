Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaAVMok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:44:40 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39349 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbaAVMoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:44:37 -0500
From: naresh.bhat@linaro.org
To: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, patches@linaro.org,
        Naresh Bhat <naresh.bhat@linaro.org>
Subject: [PATCH] watchdog: Add sp805_wdt depends on ARM64
Date: Wed, 22 Jan 2014 18:14:03 +0530
Message-Id: <1390394643-25443-1-git-send-email-naresh.bhat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naresh Bhat <naresh.bhat@linaro.org>

Add sp805_wdt depends on ARM64.

Signed-off-by: Naresh Bhat <naresh.bhat@linaro.org>
---
 drivers/watchdog/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 5be6e91..2385124 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -109,7 +109,7 @@ config WM8350_WATCHDOG
 
 config ARM_SP805_WATCHDOG
 	tristate "ARM SP805 Watchdog"
-	depends on ARM && ARM_AMBA
+	depends on (ARM || ARM64) && ARM_AMBA
 	select WATCHDOG_CORE
 	help
 	  ARM Primecell SP805 Watchdog timer. This will reboot your system when
-- 
1.7.9.5

