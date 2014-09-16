Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaIPOl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:41:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbaIPOlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:41:25 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-rpi-kernel@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] ARM: bcm2835: Enable USB_DWC2_HOST in bcm2835_defconfig
Date: Tue, 16 Sep 2014 16:40:35 +0200
Message-Id: <1410878435-12499-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It broke when host was moved into a separate module, in [47a1685f1].

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 arch/arm/configs/bcm2835_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index 0302d29..31cb073 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -98,6 +98,7 @@ CONFIG_LEDS_TRIGGER_TRANSIENT=y
 CONFIG_LEDS_TRIGGER_CAMERA=y
 CONFIG_STAGING=y
 CONFIG_USB_DWC2=y
+CONFIG_USB_DWC2_HOST=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
-- 
1.9.3

