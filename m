Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3J3HIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:08:14 -0400
Received: from [65.55.88.13] ([65.55.88.13]:50824 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753473Ab3J3HHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:07:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <s.hauer@pengutronix.de>, <swarren@wwwdotorg.org>, <t.figa@samsung.com>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [RFCv2][PATCHv5 3/4] ARM: dts: Enables FTM PWM device for Vybrid VF610 TOWER board.
Date: Wed, 30 Oct 2013 14:23:23 +0800
Message-ID: <1383114204-17264-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1383114204-17264-1-git-send-email-Li.Xiubo@freescale.com>
References: <1383114204-17264-1-git-send-email-Li.Xiubo@freescale.com>
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
 arch/arm/boot/dts/vf610-twr.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index 82d352f..3130f85 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -83,6 +83,12 @@
 	status = "okay";
 };
 
+&pwm0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_pwm0_1>;
+	status = "okay";
+};
+
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1_1>;
-- 
1.8.4


