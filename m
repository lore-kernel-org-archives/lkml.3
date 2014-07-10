Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaGJS4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:56:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40132 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaGJS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:17 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: multi_v7_defconfig: Enable Zynq GPIO driver
Date: Thu, 10 Jul 2014 11:56:08 -0700
Message-Id: <1405018568-23835-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
The driver is staged in Linus' GPIO tree.

	Sören

 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 534836497998..a439b87d87e6 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -210,6 +210,7 @@ CONFIG_PINCTRL_PALMAS=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_GENERIC_PLATFORM=y
 CONFIG_GPIO_DWAPB=y
+CONFIG_GPIO_ZYNQ=y
 CONFIG_GPIO_PCA953X=y
 CONFIG_GPIO_PCA953X_IRQ=y
 CONFIG_GPIO_TWL4030=y
-- 
2.0.1.1.gfbfc394

