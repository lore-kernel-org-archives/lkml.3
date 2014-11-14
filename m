Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897AbaKNAWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:22:19 -0500
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:56430 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754381AbaKNAUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:20:07 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, =devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V2 5/7] arm64: dts: Add APM X-Gene SoC GFC GPIO controller DTS entries
Date: Thu, 13 Nov 2014 16:19:59 -0800
Message-Id: <1415924401-3013-6-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415924401-3013-1-git-send-email-fkan@apm.com>
References: <1415924401-3013-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the flash controller muxed gpio dts node for APM X-Gene SoC platform.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 35f66fe..59f752a 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -540,6 +540,13 @@
 			};
 		};
 
+		gfcgpio: gpio0@1701c000 {
+			compatible = "apm,xgene-gpio";
+			reg = <0x0 0x1701c000 0x0 0x40>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
 		phy1: phy@1f21a000 {
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f21a000 0x0 0x100>;
-- 
1.9.1

