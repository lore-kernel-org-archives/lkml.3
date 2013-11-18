Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3KRS4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:56:25 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4908 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab3KRSzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:55:31 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
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
Subject: [PATCH 3/5] ARM: dts: Declare the PWM for bcm11351 (bcm281xx)
Date: Mon, 18 Nov 2013 10:54:59 -0800
Message-ID: <1384800901-21711-4-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E94BDF04RS9134893-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree node for the PWM on bcm11351 SoCs.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 1246885..72ba903 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -146,6 +146,14 @@
 		status = "disabled";
 	};
 
+	pwm: pwm@3e01a000 {
+		compatible = "brcm,bcm11351-pwm", "brcm,kona-pwm";
+		reg = <0x3e01a000 0xcc>;
+		clocks = <&pwm_clk>;
+		#pwm-cells = <2>;
+		status = "disabled";
+	};
+
 	clocks {
 		bsc1_clk: bsc1 {
 			compatible = "fixed-clock";
-- 
1.8.0.1


