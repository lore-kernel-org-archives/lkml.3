Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaEGXJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:09:51 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45143 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaEGXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:09:48 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 2/3] pwm: rockchip: document device tree bindings
Date: Thu,  8 May 2014 01:08:34 +0200
Message-Id: <1399504115-16257-3-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399504115-16257-1-git-send-email-b.galvani@gmail.com>
References: <1399504115-16257-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds binding documentation for Rockchip SoC PWM driver.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 .../devicetree/bindings/pwm/pwm-rockchip.txt          |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-rockchip.txt

diff --git a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
new file mode 100644
index 0000000..35deba4
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
@@ -0,0 +1,17 @@
+Rockchip PWM controller
+
+Required properties:
+ - compatible: should be "rockchip,rk2928-pwm"
+ - reg: physical base address and length of the controller's registers
+ - clocks: phandle and clock specifier of the PWM reference clock
+ - #pwm-cells: should be 2. See pwm.txt in this directory for a
+   description of the cell format
+
+Example:
+
+	pwm0: pwm@20030000 {
+		compatible = "rockchip,rk2928-pwm";
+		reg = <0x20030000 0x10>;
+		clocks = <&cru PCLK_PWM01>;
+		#pwm-cells = <2>;
+	};
-- 
1.7.10.4

