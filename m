Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaJGFFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:05:08 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60131 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaJGFFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:05:05 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: robh+dt@kernel.org, pawel.moll@arm.com
Cc: mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        jack.yoo@skyworksinc.com
Subject: [RESUBMIT PATCH v3 4/8] devicetree: backlight: add new SKY81452 backlight binding
Date: Tue,  7 Oct 2014 14:04:56 +0900
Message-Id: <1412658296-8038-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
 .../video/backlight/sky81452-backlight.txt         | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt

diff --git a/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
new file mode 100644
index 0000000..2c2d947
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
@@ -0,0 +1,24 @@
+SKY81452-backlight bindings
+
+Required properties:
+- compatible		: Must be "skyworks,sky81452-backlight"
+
+Optional properties:
+- name			: Name of backlight device. Default is 'lcd-backlight'.
+- gpio-enable		: GPIO to use to EN pin.
+- enable		: Enable mask for current sink channel 1 to 6.
+- ignore-pwm		: Ignore both PWM input
+- dpwm-mode		: Enable DPWM dimming mode, otherwise Analog dimming mode
+- phase-shift		: Enable phase shift mode
+- ovp-level		: Over-voltage protection level. Should be between 14 or 28V.
+- short-detection-threshold	: It should be one of 4, 5, 6 and 7V.
+- boost-current-limit	: It should be one of 800, 1100 and 1500mA.
+
+Example:
+
+	backlight {
+		compatible = "skyworks,sky81452-backlight";
+		name = "pwm-backlight";
+		enable = <0x3F>;
+		ignore-pwm;
+	};
-- 
1.9.1

