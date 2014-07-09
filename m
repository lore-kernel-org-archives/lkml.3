Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbaGIPYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:24:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48327 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932397AbaGIPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:34 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rodolfo Giometti <giometti@linux.it>
Subject: [PATCHv3 28/34] ARM: at91/dt: cosino define crystals frequencies
Date: Wed,  9 Jul 2014 17:06:56 +0200
Message-Id: <1404918422-7562-29-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define Cosino boards main and slow crystals frequencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Rodolfo Giometti <giometti@linux.it>
---
 arch/arm/boot/dts/at91-cosino.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/at91-cosino.dtsi b/arch/arm/boot/dts/at91-cosino.dtsi
index df4b78695695..b6ea3f4a7206 100644
--- a/arch/arm/boot/dts/at91-cosino.dtsi
+++ b/arch/arm/boot/dts/at91-cosino.dtsi
@@ -34,6 +34,14 @@
 			compatible = "atmel,osc", "fixed-clock";
 			clock-frequency = <12000000>;
 		};
+
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+
+		main_xtal {
+			clock-frequency = <12000000>;
+		};
 	};
 
 	ahb {
-- 
1.9.1

