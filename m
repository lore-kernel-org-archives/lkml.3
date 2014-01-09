Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaAIPeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:34:19 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:44907 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaAIPeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:34:09 -0500
Date: Thu, 9 Jan 2014 16:34:04 +0100
From: Gerardo Di Iorio <arete74@gmail.com>
To: maxime.ripard@free-electrons.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: [PATCH] ARM: sunxi: change the AllWinner A1X to sunxi
Message-ID: <20140109153404.GA21055@kvmhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the AllWinner A1X SOCs to Allwinner Sunxi SOCs

Signed-off-by: Gerardo Di Iorio <arete74@gmail.com>
---
 arch/arm/mach-sunxi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index 547004c..adb2574 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -1,5 +1,5 @@
 config ARCH_SUNXI
-       bool "Allwinner A1X SOCs" if ARCH_MULTI_V7
+       bool "Allwinner Sunxi SOCs" if ARCH_MULTI_V7
        select ARCH_HAS_RESET_CONTROLLER
        select ARCH_REQUIRE_GPIOLIB
        select ARM_GIC
--
1.8.4.2

