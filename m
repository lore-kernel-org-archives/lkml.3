Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3AWJuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:50:17 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:34915 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AWJuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:50:15 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 8/9] ARM: at91/at91_dt_defconfig: add at91sam9n12 SoC to DT defconfig
Date: Wed, 23 Jan 2013 10:48:55 +0100
Message-ID: <581d6299746ed264bcddc48a611343cedd10ba77.1358934163.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1358934163.git.nicolas.ferre@atmel.com>
References: <cover.1358934163.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/configs/at91_dt_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
index a353ff6..1ea9590 100644
--- a/arch/arm/configs/at91_dt_defconfig
+++ b/arch/arm/configs/at91_dt_defconfig
@@ -19,6 +19,7 @@ CONFIG_SOC_AT91SAM9260=y
 CONFIG_SOC_AT91SAM9263=y
 CONFIG_SOC_AT91SAM9G45=y
 CONFIG_SOC_AT91SAM9X5=y
+CONFIG_SOC_AT91SAM9N12=y
 CONFIG_MACH_AT91SAM_DT=y
 CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
 CONFIG_AT91_TIMER_HZ=128
-- 
1.8.0

