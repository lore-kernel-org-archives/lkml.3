Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508Ab3GWX5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:57:21 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3510 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934085Ab3GWX5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:57:20 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Christian Daudt" <csd@broadcom.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "Olof Johansson" <olof@lixom.net>, "Arnd Bergmann" <arnd@arndb.de>,
        "Stephen Warren" <swarren@wwwdotorg.org>
cc: "Christian Daudt" <csd@broadcom.com>, "arm@kernel.org" <arm@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        csd_b@daudt.org
Subject: [PATCH] MAINTAINERS: Add mach-bcm and drivers
Date: Tue, 23 Jul 2013 16:57:10 -0700
Message-ID: <1374623830-32105-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7DF1C9852L851454535-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding ownership to maintainers file for the mach-bcm related files,
including drivers that are used for the SoCs defined in mach-bcm.

Signed-off-by: Christian Daudt <csd@broadcom.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..49480494 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1785,6 +1785,17 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/bnx2x/
 
+BROADCOM BCM281XX/BCM11XXX ARM ARCHITECTURE
+M:	Christian Daudt <csd@broadcom.com>
+T:	git git://git.github.com/broadcom/bcm11351
+S:	Maintained
+F:	arch/arm/mach-bcm/
+F:	arch/arm/boot/dts/bcm113*
+F:	arch/arm/boot/dts/bcm281*
+F:	arch/arm/configs/bcm_defconfig
+F:	drivers/mmc/host/sdhci_bcm_kona.c
+F:	drivers/clocksource/bcm_kona_timer.c
+
 BROADCOM BCM2835 ARM ARCHICTURE
 M:	Stephen Warren <swarren@wwwdotorg.org>
 L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.7.10.4


