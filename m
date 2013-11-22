Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab3KVW4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:56:44 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2561 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab3KVW4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:56:37 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Markus Mayer" <markus.mayer@linaro.org>
To: "Wim Van Sebroeck" <wim@iguana.be>, "Guenter Roeck" <linux@roeck-us.net>,
        "Christian Daudt" <bcm@fixthebug.org>
cc: "Linaro Patches" <patches@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "One Thousand Gnomes" <gnomes@lxorguk.ukuu.org.uk>,
        "Linux Watchdog List" <linux-watchdog@vger.kernel.org>,
        "ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Markus Mayer" <markus.mayer@linaro.org>
Subject: [PATCH v5 2/2] ARM: bcm281xx: watchdog configuration
Date: Fri, 22 Nov 2013 14:56:04 -0800
Message-ID: <1385160964-18578-3-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385160964-18578-1-git-send-email-markus.mayer@linaro.org>
References: <1385160964-18578-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E913F744RS10428148-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit enables the watchdog driver for the BCM281xx family of SoCs.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Acked-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/arm/configs/bcm_defconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 287ac1d..d4d0083 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -126,3 +126,6 @@ CONFIG_CRC_ITU_T=y
 CONFIG_CRC7=y
 CONFIG_XZ_DEC=y
 CONFIG_AVERAGE=y
+CONFIG_WATCHDOG=y
+CONFIG_BCM_KONA_WDT=y
+CONFIG_BCM_KONA_WDT_DEBUG=y
-- 
1.7.9.5


