Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201AbaDIQXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:23:43 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58453 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941AbaDIQX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:23:27 -0400
X-IronPort-AV: E=Sophos;i="4.97,827,1389772800"; 
   d="scan'208";a="23482617"
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>,
        Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, "Rob Landley" <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [RESEND PATCH v5 5/5] ARM: bcm_defconfig: Enable PWM and Backlight
Date: Wed, 9 Apr 2014 09:23:11 -0700
Message-ID: <1397060591-5060-6-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397060591-5060-1-git-send-email-tim.kryger@linaro.org>
References: <1397060591-5060-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PWM drivers and the PWM-based backlight driver.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/configs/bcm_defconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 3b2b7bd..593df57 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -88,6 +88,7 @@ CONFIG_FB=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
+CONFIG_BACKLIGHT_PWM=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
 CONFIG_MMC_UNSAFE_RESUME=y
@@ -101,6 +102,8 @@ CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_PWM=y
+CONFIG_PWM_BCM_KONA=y
 CONFIG_EXT4_FS=y
 CONFIG_EXT4_FS_POSIX_ACL=y
 CONFIG_EXT4_FS_SECURITY=y
-- 
1.7.9.5

