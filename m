Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaE0Mp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:45:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:2657 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaE0Mp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:45:29 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, ARM Maintainers <arm@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/defconfig: sama5_defconfig: updated
Date: Tue, 27 May 2014 14:45:21 +0200
Message-ID: <1401194721-22586-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenyou Yang <wenyou.yang@atmel.com>

due to enabling
	-- CONFIG_REGULATOR
	-- CONFIG_REGULATOR_ACT8865

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
[nicolas.ferre@atmel.com: move added entries to proper location within file]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Arnd, Olof, Kevin,

I have this little patch lying around without other updates to AT91
defconfig files so far. Is it possible to take this patch in arm-soc
without a pull-request?

Thanks, best regards,

Nicolas Ferre


 arch/arm/configs/sama5_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index 869fa18ebeb2..4414990521d3 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -137,6 +137,8 @@ CONFIG_SPI_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_SSB=m
+CONFIG_REGULATOR=y
+CONFIG_REGULATOR_ACT8865=y
 CONFIG_FB=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
-- 
1.8.2.2

