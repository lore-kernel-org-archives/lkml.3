Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaKSD00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:26:26 -0500
Received: from regular1.263xmail.com ([211.150.99.140]:34656 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaKSD0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:26:25 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <273e7a441d9eed9813a334fac48cacf6>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, kever.yang@rock-chips.com, cf@rock-chips.com,
        fzf@rock-chips.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, chris.zhong@rock-chips.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH] ARM: dts: fix PWM clock found on RK3288 Socs
Date: Wed, 19 Nov 2014 11:25:54 +0800
Message-Id: <1416367554-15185-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the new PWM IP on RK3288,but the PWM's clock indeed incorrect.

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index cb18bb4..76bff02 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -418,7 +418,7 @@
 		#pwm-cells = <3>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pwm0_pin>;
-		clocks = <&cru PCLK_PWM>;
+		clocks = <&cru PCLK_RKPWM>;
 		clock-names = "pwm";
 		status = "disabled";
 	};
@@ -429,7 +429,7 @@
 		#pwm-cells = <3>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pwm1_pin>;
-		clocks = <&cru PCLK_PWM>;
+		clocks = <&cru PCLK_RKPWM>;
 		clock-names = "pwm";
 		status = "disabled";
 	};
@@ -440,7 +440,7 @@
 		#pwm-cells = <3>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pwm2_pin>;
-		clocks = <&cru PCLK_PWM>;
+		clocks = <&cru PCLK_RKPWM>;
 		clock-names = "pwm";
 		status = "disabled";
 	};
@@ -451,7 +451,7 @@
 		#pwm-cells = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pwm3_pin>;
-		clocks = <&cru PCLK_PWM>;
+		clocks = <&cru PCLK_RKPWM>;
 		clock-names = "pwm";
 		status = "disabled";
 	};
-- 
1.9.1


