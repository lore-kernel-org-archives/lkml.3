Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaBSIrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:47:10 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:50813
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037AbaBSIrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:47:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <linux-arm-kernel@lists.infradead.org>, <shawn.guo@linaro.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 1/4] ARM: dts: vf610: Add edma mux Tx and Rx support for SAI node.
Date: Wed, 19 Feb 2014 15:42:28 +0800
Message-ID: <1392795751-13351-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392795751-13351-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392795751-13351-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SAI's edma mux Tx and Rx support.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/boot/dts/vf610.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 91a7757..f08df47 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -169,6 +169,9 @@
 				interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks VF610_CLK_SAI2>;
 				clock-names = "sai";
+				dma-names = "tx", "rx";
+				dmas = <&edma0 0 21>,
+					<&edma0 0 20>;
 				status = "disabled";
 			};
 
-- 
1.8.4


