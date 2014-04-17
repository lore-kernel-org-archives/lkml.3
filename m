Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaDQImm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:42:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54294 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750852AbaDQImj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:42:39 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, arm@kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: multi_v7_defconfig: select CONFIG_GPIO_DWAPB
Date: Thu, 17 Apr 2014 10:42:30 +0200
Message-Id: <1397724150-14055-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly integrated dwapb gpio driver handles the Berlin SoCs GPIOs.
Add this driver to the multi_v7_defconfig.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 This patch applies on top of Alexandre's one selecting
 CONFIG_MACH_BERLIN_BG2Q:
 https://patchwork.kernel.org/patch/3876171/

 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index b61a211cc221..ded037aff67d 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -192,6 +192,7 @@ CONFIG_PINCTRL_AS3722=y
 CONFIG_PINCTRL_PALMAS=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_GENERIC_PLATFORM=y
+CONFIG_GPIO_DWAPB=y
 CONFIG_GPIO_PCA953X_IRQ=y
 CONFIG_GPIO_TWL4030=y
 CONFIG_GPIO_PALMAS=y
-- 
1.8.3.2

