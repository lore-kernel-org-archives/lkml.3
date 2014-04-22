Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbaDVNNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:13:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48491 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752128AbaDVNMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:12:53 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 11/11] ARM: at91/dt: define sam9rlek crystal frequencies
Date: Tue, 22 Apr 2014 15:12:40 +0200
Message-Id: <1398172360-7837-12-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9rlek crystal frequencies.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9rlek.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9rlek.dts b/arch/arm/boot/dts/at91sam9rlek.dts
index cddb378..b3b89ba 100644
--- a/arch/arm/boot/dts/at91sam9rlek.dts
+++ b/arch/arm/boot/dts/at91sam9rlek.dts
@@ -20,6 +20,15 @@
 		reg = <0x20000000 0x4000000>;
 	};
 
+
+	slow_xtal {
+		clock-frequency = <32768>;
+	};
+
+	main_xtal {
+		clock-frequency = <12000000>;
+	};
+
 	clocks {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.8.3.2

