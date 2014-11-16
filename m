Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbaKPAU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:20:58 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54074 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbaKPATx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:19:53 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 21/22] MAINTAINERS: Add entry for BMIPS multiplatform kernel
Date: Sat, 15 Nov 2014 16:17:45 -0800
Message-Id: <1416097066-20452-22-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as a maintainer for the new BMIPS target.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6ab20b4..e96b4ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2108,6 +2108,18 @@ S:	Maintained
 F:	arch/arm/mach-bcm/*brcmstb*
 F:	arch/arm/boot/dts/bcm7*.dts*
 
+BROADCOM BMIPS MIPS ARCHITECTURE
+M:	Kevin Cernekee <cernekee@gmail.com>
+M:	Florian Fainelli <f.fainelli@gmail.com>
+L:	linux-mips@linux-mips.org
+S:	Maintained
+F:	arch/mips/bmips/*
+F:	arch/mips/include/asm/mach-bmips/*
+F:	arch/mips/kernel/*bmips*
+F:	arch/mips/boot/dts/bcm*.dts*
+F:	drivers/irqchip/irq-bcm7*
+F:	drivers/irqchip/irq-brcmstb*
+
 BROADCOM TG3 GIGABIT ETHERNET DRIVER
 M:	Prashant Sreedharan <prashant@broadcom.com>
 M:	Michael Chan <mchan@broadcom.com>
-- 
2.1.1

