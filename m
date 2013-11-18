Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3KRS5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:57:13 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1174 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3KRSz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:55:27 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Thierry Reding" <thierry.reding@gmail.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Grant Likely" <grant.likely@linaro.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Linux PWM List" <linux-pwm@vger.kernel.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux Doc List" <linux-doc@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Broadcom Kernel Feedback List" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH 5/5] ARM: bcm_defconfig: Enable PWM and Backlight
Date: Mon, 18 Nov 2013 10:55:01 -0800
Message-ID: <1384800901-21711-6-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E94BDE91SC9038040-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PWM drivers and the PWM-based baclight driver.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/configs/bcm_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index fcea348..04a58f34 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -85,6 +85,7 @@ CONFIG_FB=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
+CONFIG_BACKLIGHT_PWM=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
 CONFIG_MMC_UNSAFE_RESUME=y
@@ -98,6 +99,7 @@ CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_PWM=y
 CONFIG_EXT4_FS=y
 CONFIG_EXT4_FS_POSIX_ACL=y
 CONFIG_EXT4_FS_SECURITY=y
-- 
1.8.0.1


