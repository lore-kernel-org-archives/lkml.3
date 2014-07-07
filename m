Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaGGU2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:28:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60161 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752418AbaGGUYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:24:12 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Tim Schendekehl <tim.schendekehl@egnite.de>
Subject: [PATCHv2 18/32] ARM: at91/dt: ethernut5: define crystals frequencies
Date: Mon,  7 Jul 2014 22:23:35 +0200
Message-Id: <1404764629-29136-19-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404764629-29136-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404764629-29136-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define egnite Ethernut 5 main and slow crystals frequencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Tim Schendekehl <tim.schendekehl@egnite.de>
---
 arch/arm/boot/dts/ethernut5.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/ethernut5.dts b/arch/arm/boot/dts/ethernut5.dts
index 143b6d25bc80..8f941c2db7c6 100644
--- a/arch/arm/boot/dts/ethernut5.dts
+++ b/arch/arm/boot/dts/ethernut5.dts
@@ -20,6 +20,16 @@
 		reg = <0x20000000 0x08000000>;
 	};
 
+	clocks {
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+
+		main_xtal {
+			clock-frequency = <18432000>;
+		};
+	};
+
 	ahb {
 		apb {
 			dbgu: serial@fffff200 {
-- 
1.9.1

