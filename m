Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaCRNTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:19:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37525 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbaCRNTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:19:19 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH] ARM: dts: keystone: Fix domain register range for clkfftc1
Date: Tue, 18 Mar 2014 15:18:17 +0200
Message-ID: <1395148697-22481-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The domain register range for clkfftc1 has to be 0x0235004c
instead of 0x023504c0.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/boot/dts/k2hk-clocks.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/k2hk-clocks.dtsi b/arch/arm/boot/dts/k2hk-clocks.dtsi
index 8855b1f..96e6536 100644
--- a/arch/arm/boot/dts/k2hk-clocks.dtsi
+++ b/arch/arm/boot/dts/k2hk-clocks.dtsi
@@ -209,7 +209,7 @@ clocks {
 		compatible = "ti,keystone,psc-clock";
 		clocks = <&chipclk13>;
 		clock-output-names = "fftc-1";
-		reg = <0x02350074 0xb00>, <0x023504c0 0x400>;
+		reg = <0x02350074 0xb00>, <0x0235004c 0x400>;
 		reg-names = "control", "domain";
 		domain-id = <19>;
 	};
-- 
1.8.3.2

