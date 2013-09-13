Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3IMGDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:03:18 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:1623
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128Ab3IMGDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:03:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <s.hauer@pengutronix.de>, <swarren@wwwdotorg.org>, <t.figa@samsung.com>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCHv4 3/4] ARM: dts: Enables FTM PWM device for Vybrid VF610 TOWER board.
Date: Fri, 13 Sep 2013 13:58:41 +0800
Message-ID: <1379051922-4930-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
References: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selecting system clock as the counter source clock by default.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/vf610-twr.dts | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index 1a58678..27cbe91 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -57,6 +57,31 @@
 	status = "okay";
 };
 
+&pwm0 {
+	fsl,pwm-counter-clk = "ftm0";
+	pinctrl-names = "ch0-active", "ch0-idle", "ch1-active", "ch1-idle",
+			"ch2-active", "ch2-idle", "ch3-active", "ch3-idle",
+			"ch4-active", "ch4-idle", "ch5-active", "ch5-idle",
+			"ch6-active", "ch6-idle", "ch7-active", "ch7-idle";
+	pinctrl-0 = <&pinctrl_pwm0_ch0_active>;
+	pinctrl-1 = <&pinctrl_pwm0_ch0_idle>;
+	pinctrl-2 = <&pinctrl_pwm0_ch1_active>;
+	pinctrl-3 = <&pinctrl_pwm0_ch1_idle>;
+	pinctrl-4 = <&pinctrl_pwm0_ch2_active>;
+	pinctrl-5 = <&pinctrl_pwm0_ch2_idle>;
+	pinctrl-6 = <&pinctrl_pwm0_ch3_active>;
+	pinctrl-7 = <&pinctrl_pwm0_ch3_idle>;
+	pinctrl-8 = <&pinctrl_pwm0_ch4_active>;
+	pinctrl-9 = <&pinctrl_pwm0_ch4_idle>;
+	pinctrl-10 = <&pinctrl_pwm0_ch5_active>;
+	pinctrl-11 = <&pinctrl_pwm0_ch5_idle>;
+	pinctrl-12 = <&pinctrl_pwm0_ch6_active>;
+	pinctrl-13 = <&pinctrl_pwm0_ch6_idle>;
+	pinctrl-14 = <&pinctrl_pwm0_ch7_active>;
+	pinctrl-15 = <&pinctrl_pwm0_ch7_idle>;
+	status = "okay";
+};
+
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1_1>;
-- 
1.8.0


