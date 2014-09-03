Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaICHsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:48:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43287 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755698AbaICHsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:48:39 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/12] ARM: Berlin: select the reset controller
Date: Wed,  3 Sep 2014 09:48:22 +0200
Message-Id: <1409730511-16101-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409730511-16101-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1409730511-16101-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Berlin SoCs now has a reset controller. Add the needed
configuration.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/mach-berlin/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index 24f85be71671..5803f773a065 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -1,11 +1,13 @@
 menuconfig ARCH_BERLIN
 	bool "Marvell Berlin SoCs" if ARCH_MULTI_V7
+	select ARCH_HAS_RESET_CONTROLLER
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_GIC
 	select GENERIC_IRQ_CHIP
 	select DW_APB_ICTL
 	select DW_APB_TIMER_OF
 	select PINCTRL
+	select RESET_CONTROLLER
 
 if ARCH_BERLIN
 
-- 
1.9.1

