Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbaGCOXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:23:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51001 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758582AbaGCOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:41 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 04/18] AT91: SAMA5D3: DT: Add shutdown controller
Date: Thu,  3 Jul 2014 16:14:38 +0200
Message-Id: <1404396906-25194-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SAMA5D3 has a shutdown controller identical to the sam9x5 SoC family.
Declare it in the DT.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index e0b15a6e8897..8bcf1c442c96 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1178,6 +1178,11 @@
 				reg = <0xfffffe00 0x10>;
 			};
 
+			shutdown-controller@fffffe10 {
+				compatible = "atmel,at91sam9x5-shdwc";
+				reg = <0xfffffe10 0x10>;
+			};
+
 			pit: timer@fffffe30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
-- 
2.0.1

