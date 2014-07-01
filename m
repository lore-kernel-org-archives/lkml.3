Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaGAOOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:14:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35646 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932319AbaGAOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>
Subject: [PATCH 18/33] ARM: at91/dt: ge863-pro3: define crystals frequencies
Date: Tue,  1 Jul 2014 16:12:27 +0200
Message-Id: <1404223962-30471-19-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define Telit GE863-PRO3, AK signal CDU and Telit EVK-PRO3 main and slow
crystals frequencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Jiri Prchal <jiri.prchal@aksignal.cz>
---
 arch/arm/boot/dts/ge863-pro3.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/ge863-pro3.dtsi b/arch/arm/boot/dts/ge863-pro3.dtsi
index 230099bb31c8..a32fdbefbbd9 100644
--- a/arch/arm/boot/dts/ge863-pro3.dtsi
+++ b/arch/arm/boot/dts/ge863-pro3.dtsi
@@ -19,6 +19,14 @@
 			compatible = "atmel,osc", "fixed-clock";
 			clock-frequency = <6000000>;
 		};
+
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+
+		main_xtal {
+			clock-frequency = <6000000>;
+		};
 	};
 
 	ahb {
-- 
1.9.1

