Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbaAFV46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:56:58 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:59327 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaAFV44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:56:56 -0500
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="8064893"
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
CC: Linaro Patches <patches@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH v2 2/2] watchdog: bcm281xx: Turn on debugfs support for watchdog driver
Date: Mon, 6 Jan 2014 13:56:11 -0800
Message-ID: <1389045371-1631-3-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389045371-1631-1-git-send-email-markus.mayer@linaro.org>
References: <1389045371-1631-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change turns on debugfs support for the BCM281xx watchdog driver.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/configs/bcm_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 10d1392..d4d0083 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -128,3 +128,4 @@ CONFIG_XZ_DEC=y
 CONFIG_AVERAGE=y
 CONFIG_WATCHDOG=y
 CONFIG_BCM_KONA_WDT=y
+CONFIG_BCM_KONA_WDT_DEBUG=y
-- 
1.7.9.5

