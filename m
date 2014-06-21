Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaFUWLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 18:11:23 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:33957 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaFUWLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 18:11:21 -0400
X-ME-Helo: localhost.localdomain
X-ME-Date: Sun, 22 Jun 2014 00:11:20 +0200
X-ME-IP: 109.214.175.13
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 3/3] ARM: add CLKSRC_OF dependency for PXA
Date: Sun, 22 Jun 2014 00:09:48 +0200
Message-Id: <1403388588-11956-3-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
References: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select CLKSRC_OF for PXA architectures, as the clocksource
driver can be also initialized from device-tree.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index db3c541..c300b68 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -646,6 +646,7 @@ config ARCH_PXA
 	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
+	select CLKSRC_OF if OF
 	select GENERIC_CLOCKEVENTS
 	select GPIO_PXA
 	select HAVE_IDE
-- 
2.0.0.rc2

