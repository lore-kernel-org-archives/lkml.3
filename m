Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaBDMUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:20:23 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:64742 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaBDMT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:19:26 -0500
From: Matt Porter <mporter@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] ARM: configs: bcm_defconfig: enable bcm59056 regulator support
Date: Tue,  4 Feb 2014 07:19:11 -0500
Message-Id: <1391516352-32359-6-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1391516352-32359-1-git-send-email-mporter@linaro.org>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable BCM59056 MFD and regulator drivers to manage voltage
regulators on BCM281xx platforms.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/configs/bcm_defconfig | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 2519d6d..35752cc 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -79,6 +79,13 @@ CONFIG_HW_RANDOM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 # CONFIG_HWMON is not set
+CONFIG_MFD_BCM59056=y
+CONFIG_REGULATOR=y
+CONFIG_REGULATOR_FIXED_VOLTAGE=y
+CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
+CONFIG_REGULATOR_USERSPACE_CONSUMER=y
+CONFIG_REGULATOR_BCM59056=y
+
 CONFIG_VIDEO_OUTPUT_CONTROL=y
 CONFIG_FB=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
-- 
1.8.4

