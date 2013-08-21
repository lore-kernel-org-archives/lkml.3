Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3HUDKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:10:55 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:36845
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab3HUDKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:10:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [PATCH 3/4] ARM: dts: Enables ftm pwm device for Vybrid VF610 TOWER board.
Date: Wed, 21 Aug 2013 11:07:41 +0800
Message-ID: <1377054462-6283-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/vf610-twr.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index b3905f5..6f93d8d 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -50,6 +50,23 @@
 	status = "okay";
 };
 
+&pwm0 {
+	pinctrl-names = "en0", "ds0", "en1", "ds1", "en2", "ds2", "en3", "ds3";
+	pinctrl-0 = <&pinctrl_pwm0_ch0_en>;
+	pinctrl-1 = <&pinctrl_pwm0_ch0_ds>;
+	pinctrl-2 = <&pinctrl_pwm0_ch1_en>;
+	pinctrl-3 = <&pinctrl_pwm0_ch1_ds>;
+	pinctrl-4 = <&pinctrl_pwm0_ch2_en>;
+	pinctrl-5 = <&pinctrl_pwm0_ch2_ds>;
+	pinctrl-6 = <&pinctrl_pwm0_ch3_en>;
+	pinctrl-7 = <&pinctrl_pwm0_ch3_ds>;
+	fsl,pwm-clk-ps = <7>;
+	fsl,pwm-cpwm = <0>;
+	fsl,pwm-number = <4>;
+	fsl,pwm-channels = <0 1 2 3>;
+	status = "okay";
+};
+
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1_1>;
-- 
1.8.0


