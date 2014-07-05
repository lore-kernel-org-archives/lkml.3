Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaGELOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 07:14:49 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:60559 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaGELOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 07:14:01 -0400
X-ME-Helo: localhost.localdomain
X-ME-Date: Sat, 05 Jul 2014 13:14:00 +0200
X-ME-IP: 86.199.194.180
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 3/4] arm: pxa: add CLKSRC_OF dependency
Date: Sat,  5 Jul 2014 13:13:00 +0200
Message-Id: <1404558781-9537-3-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404558781-9537-1-git-send-email-robert.jarzmik@free.fr>
References: <1404558781-9537-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select CLKSRC_OF for PXA architectures.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 87b63fd..472dea1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -644,6 +644,7 @@ config ARCH_PXA
 	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
+	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
 	select GPIO_PXA
 	select HAVE_IDE
-- 
2.0.0.rc2

