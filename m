Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaDNInw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:43:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56920 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753777AbaDNInp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:43:45 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 3/4] ARM: at91/dt: define sam9x5ek's crystal frequencies
Date: Mon, 14 Apr 2014 10:43:13 +0200
Message-Id: <1397464994-27267-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397464994-27267-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397464994-27267-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define sam9x5ek's main and slow crystal frequencies.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9x5cm.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5cm.dtsi b/arch/arm/boot/dts/at91sam9x5cm.dtsi
index 4a5ee5c..2798b02 100644
--- a/arch/arm/boot/dts/at91sam9x5cm.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5cm.dtsi
@@ -23,6 +23,14 @@
 		};
 	};
 
+	slow_xtal: slow_xtal {
+		clock-frequency = <32768>;
+	};
+
+	main_xtal: main_xtal {
+		clock-frequency = <12000000>;
+	};
+
 	ahb {
 		apb {
 			pinctrl@fffff400 {
-- 
1.8.3.2

