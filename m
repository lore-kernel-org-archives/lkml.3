Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaDBQ16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:27:58 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:60597 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbaDBQ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:27:44 -0400
X-IronPort-AV: E=Sophos;i="4.97,780,1389772800"; 
   d="scan'208";a="22851461"
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
Subject: [RESEND PATCH v5 3/5] ARM: dts: Declare the PWM for bcm11351 (bcm281xx)
Date: Wed, 2 Apr 2014 09:27:22 -0700
Message-ID: <1396456044-19427-4-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396456044-19427-1-git-send-email-tim.kryger@linaro.org>
References: <1396456044-19427-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree node for the PWM on bcm11351 SoCs.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 64d069b..6b05ae6 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -193,6 +193,14 @@
 		status = "disabled";
 	};
 
+	pwm: pwm@3e01a000 {
+		compatible = "brcm,bcm11351-pwm", "brcm,kona-pwm";
+		reg = <0x3e01a000 0xcc>;
+		clocks = <&slave_ccu BCM281XX_SLAVE_CCU_PWM>;
+		#pwm-cells = <3>;
+		status = "disabled";
+	};
+
 	clocks {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.9.5

