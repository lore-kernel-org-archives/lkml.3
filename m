Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaGAOOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:14:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35615 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932203AbaGAOOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:08 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 13/33] ARM: at91/dt: foxg20: define crystals frequencies
Date: Tue,  1 Jul 2014 16:12:22 +0200
Message-Id: <1404223962-30471-14-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define Acme Systems srl Fox G20 main and slow crystals frequencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
---
 arch/arm/boot/dts/at91-foxg20.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/at91-foxg20.dts b/arch/arm/boot/dts/at91-foxg20.dts
index cbe967343997..f89598af4c2b 100644
--- a/arch/arm/boot/dts/at91-foxg20.dts
+++ b/arch/arm/boot/dts/at91-foxg20.dts
@@ -31,6 +31,14 @@
 			compatible = "atmel,osc", "fixed-clock";
 			clock-frequency = <18432000>;
 		};
+
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+
+		main_xtal {
+			clock-frequency = <18432000>;
+		};
 	};
 
 	ahb {
-- 
1.9.1

