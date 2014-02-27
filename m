Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaB0LYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:24:30 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44172 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752097AbaB0LWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:22:42 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 3/9] ARM: at91/defconfig: Add the sam9rl to the list of DT-enabled SOCs
Date: Thu, 27 Feb 2014 12:22:09 +0100
Message-Id: <1393500135-29636-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393500135-29636-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393500135-29636-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9rl now has a device tree, add it to the at91_dt_defconfig.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/at91_dt_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
index 0b4e9b5210d8..d0bddb699865 100644
--- a/arch/arm/configs/at91_dt_defconfig
+++ b/arch/arm/configs/at91_dt_defconfig
@@ -20,6 +20,7 @@ CONFIG_SOC_AT91SAM9263=y
 CONFIG_SOC_AT91SAM9G45=y
 CONFIG_SOC_AT91SAM9X5=y
 CONFIG_SOC_AT91SAM9N12=y
+CONFIG_SOC_AT91SAM9RL=y
 CONFIG_MACH_AT91RM9200_DT=y
 CONFIG_MACH_AT91SAM9_DT=y
 CONFIG_AT91_TIMER_HZ=128
-- 
1.8.3.2

