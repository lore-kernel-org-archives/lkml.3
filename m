Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaGMV7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 17:59:46 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:49027 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaGMV7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 17:59:41 -0400
From: Nicolas Del Piano <ndel314@gmail.com>
To: rjw@rjwysocki.net
Cc: viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ezequiel@vanguardiasur.com.ar,
        Nicolas Del Piano <ndel314@gmail.com>
Subject: [PATCH] Cpufreq: ARM IMX6Q: Select PM_OPP
Date: Sun, 13 Jul 2014 18:59:00 -0300
Message-Id: <1405288740-3986-1-git-send-email-ndel314@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM_OPP is a library used by several of the existing cpufreq drivers.
ARM IMX6Q cpufreq driver uses this library for its functionality.
Thus, it should be selected in Kconfig.

Reported-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
---
 drivers/cpufreq/Kconfig.arm |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index ebac671..8c5cf4b 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -104,6 +104,7 @@ config ARM_IMX6Q_CPUFREQ
 	tristate "Freescale i.MX6 cpufreq support"
 	depends on ARCH_MXC
 	depends on REGULATOR_ANATOP
+	select PM_OPP
 	help
 	  This adds cpufreq driver support for Freescale i.MX6 series SoCs.
 
-- 
1.7.9.5

