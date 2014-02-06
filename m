Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaBFPaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:30:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37543 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbaBFPaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:30:01 -0500
From: Nishanth Menon <nm@ti.com>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: multi_v7_defconfig: Select CONFIG_SOC_DRA7XX
Date: Thu, 6 Feb 2014 09:29:31 -0600
Message-ID: <1391700571-31784-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select CONFIG_SOC_DRA7XX so that we can boot dra7-evm.
DRA7 family are A15 based processors that supports LPAE and an
evolutionary update to the OMAP5 generation of processors.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

based on v3.13-rc1 kernel tag - tested on v3.14-rc1 and next-20140206

 arch/arm/configs/multi_v7_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 845bc74..ee69829 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -29,6 +29,7 @@ CONFIG_ARCH_OMAP3=y
 CONFIG_ARCH_OMAP4=y
 CONFIG_SOC_OMAP5=y
 CONFIG_SOC_AM33XX=y
+CONFIG_SOC_DRA7XX=y
 CONFIG_SOC_AM43XX=y
 CONFIG_ARCH_ROCKCHIP=y
 CONFIG_ARCH_SOCFPGA=y
-- 
1.7.9.5

