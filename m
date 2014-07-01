Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbaGAOPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:15:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35723 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932638AbaGAOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:58 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Gregory Hermant <gregory.hermant@calao-systems.com>
Subject: [PATCH 33/33] ARM: at91/dt: usb_a9263: define crystals frequencies
Date: Tue,  1 Jul 2014 16:12:42 +0200
Message-Id: <1404223962-30471-34-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define Calao USB-A9263 main and slow crystals frequencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Gregory Hermant <gregory.hermant@calao-systems.com>
---
 arch/arm/boot/dts/usb_a9263.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/usb_a9263.dts b/arch/arm/boot/dts/usb_a9263.dts
index 290e60383baf..68c0de36c339 100644
--- a/arch/arm/boot/dts/usb_a9263.dts
+++ b/arch/arm/boot/dts/usb_a9263.dts
@@ -29,6 +29,14 @@
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

