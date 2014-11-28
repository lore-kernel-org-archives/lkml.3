Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbaK1SGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:06:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42106 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751002AbaK1SGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:06:07 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Josh Wu <josh.wu@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v3 2/3] ARM: at91: sama5d3: Add SFR
Date: Fri, 28 Nov 2014 19:06:01 +0100
Message-Id: <1417197962-19441-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417197962-19441-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1417197962-19441-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sama5d3 has Special Function Registers that allow to manage OHCI, EBI and
the UTMI clock.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 5f4144d1e3a1..499b59f48055 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -217,6 +217,11 @@
 				status = "disabled";
 			};
 
+			sfr: sfr@f0038000 {
+				compatible = "atmel,sama5d3-sfr", "syscon";
+				reg = <0xf0038000 0x4000>;
+			};
+
 			mmc1: mmc@f8000000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf8000000 0x600>;
-- 
2.1.0

