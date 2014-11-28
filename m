Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbaK1UeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 15:34:01 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:57918 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaK1UeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 15:34:00 -0500
X-ME-Helo: beldin.home
X-ME-Date: Fri, 28 Nov 2014 21:33:58 +0100
X-ME-IP: 90.11.113.15
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] arm: pxa: fix pxa27x device-tree support kconfig
Date: Fri, 28 Nov 2014 21:32:48 +0100
Message-Id: <1417206768-5840-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the useless CPU_PXA27x non existing kconfig option.
The true options is PXA27x, which is already selected.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 83efe91..5f71c06 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -6,7 +6,6 @@ comment "Intel/Marvell Dev Platforms (sorted by hardware release time)"
 
 config MACH_PXA27X_DT
 	bool "Support PXA27x platforms from device tree"
-	select CPU_PXA27x
 	select POWER_SUPPLY
 	select PXA27x
 	select USE_OF
-- 
2.1.0

