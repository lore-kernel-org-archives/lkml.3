Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936139Ab3DKDrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:47:55 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:38970
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760111Ab3DKDry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:47:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Vakul Garg <vakul@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Andy Fleming <afleming@freescale.com>,
        Shaveta Leekha <shaveta@freescale.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc/crypto: removed qoriq-sec4.1-0.dtsi.
Date: Thu, 11 Apr 2013 09:13:39 +0530
Message-ID: <1365651819-23350-1-git-send-email-vakul@freescale.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing qoriq-sec4.1-0.dtsi as it is not used by any soc anymore.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
 arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi |  109 -------------------------
 1 files changed, 0 insertions(+), 109 deletions(-)
 delete mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi
deleted file mode 100644
index 3308986..0000000
--- a/arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi
+++ /dev/null
@@ -1,109 +0,0 @@
-/*
- * QorIQ Sec/Crypto 4.1 device tree stub [ controller @ offset 0x300000 ]
- *
- * Copyright 2011 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-crypto: crypto@300000 {
-	compatible = "fsl,sec-v4.1", "fsl,sec-v4.0";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	reg		 = <0x300000 0x10000>;
-	ranges		 = <0 0x300000 0x10000>;
-	interrupts	 = <92 2 0 0>;
-
-	sec_jr0: jr@1000 {
-		compatible = "fsl,sec-v4.1-job-ring",
-			     "fsl,sec-v4.0-job-ring";
-		reg = <0x1000 0x1000>;
-		interrupts = <88 2 0 0>;
-	};
-
-	sec_jr1: jr@2000 {
-		compatible = "fsl,sec-v4.1-job-ring",
-			     "fsl,sec-v4.0-job-ring";
-		reg = <0x2000 0x1000>;
-		interrupts = <89 2 0 0>;
-	};
-
-	sec_jr2: jr@3000 {
-		compatible = "fsl,sec-v4.1-job-ring",
-			     "fsl,sec-v4.0-job-ring";
-		reg = <0x3000 0x1000>;
-		interrupts = <90 2 0 0>;
-	};
-
-	sec_jr3: jr@4000 {
-		compatible = "fsl,sec-v4.1-job-ring",
-			     "fsl,sec-v4.0-job-ring";
-		reg = <0x4000 0x1000>;
-		interrupts = <91 2 0 0>;
-	};
-
-	rtic@6000 {
-		compatible = "fsl,sec-v4.1-rtic",
-			     "fsl,sec-v4.0-rtic";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		reg = <0x6000 0x100>;
-		ranges = <0x0 0x6100 0xe00>;
-
-		rtic_a: rtic-a@0 {
-			compatible = "fsl,sec-v4.1-rtic-memory",
-				     "fsl,sec-v4.0-rtic-memory";
-			reg = <0x00 0x20 0x100 0x80>;
-		};
-
-		rtic_b: rtic-b@20 {
-			compatible = "fsl,sec-v4.1-rtic-memory",
-				     "fsl,sec-v4.0-rtic-memory";
-			reg = <0x20 0x20 0x200 0x80>;
-		};
-
-		rtic_c: rtic-c@40 {
-			compatible = "fsl,sec-v4.1-rtic-memory",
-				     "fsl,sec-v4.0-rtic-memory";
-			reg = <0x40 0x20 0x300 0x80>;
-		};
-
-		rtic_d: rtic-d@60 {
-			compatible = "fsl,sec-v4.1-rtic-memory",
-				     "fsl,sec-v4.0-rtic-memory";
-			reg = <0x60 0x20 0x500 0x80>;
-		};
-	};
-};
-
-sec_mon: sec_mon@314000 {
-	compatible = "fsl,sec-v4.1-mon", "fsl,sec-v4.0-mon";
-	reg = <0x314000 0x1000>;
-	interrupts = <93 2 0 0>;
-};
-- 
1.7.7.6


