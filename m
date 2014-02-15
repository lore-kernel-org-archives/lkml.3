Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaBOBPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 20:15:34 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59697 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753094AbaBOBOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 20:14:38 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/3] ARM: at91/defconfig: Add the sam9rl to the list of DT-enabled SOCs
Date: Sat, 15 Feb 2014 02:14:19 +0100
Message-Id: <1392426860-19589-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392426860-19589-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1392426860-19589-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9rl now has a device tree, add it to the at91_dt_defconfig.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/at91_dt_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
index 690e89273230..c03f5f4c79f6 100644
--- a/arch/arm/configs/at91_dt_defconfig
+++ b/arch/arm/configs/at91_dt_defconfig
@@ -20,6 +20,7 @@ CONFIG_SOC_AT91SAM9263=y
 CONFIG_SOC_AT91SAM9G45=y
 CONFIG_SOC_AT91SAM9X5=y
 CONFIG_SOC_AT91SAM9N12=y
+CONFIG_SOC_AT91SAM9RL=y
 CONFIG_MACH_AT91RM9200_DT=y
 CONFIG_MACH_AT91SAM9_DT=y
 CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
-- 
1.8.3.2

