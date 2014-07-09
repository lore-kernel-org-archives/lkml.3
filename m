Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaGIPdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:33:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48327 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932290AbaGIPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:27 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 18/34] ARM: at91/dt: aks-cdu: define slow crytal frequency
Date: Wed,  9 Jul 2014 17:06:46 +0200
Message-Id: <1404918422-7562-19-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define AK signal CDU slow crystal frequency

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/aks-cdu.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/aks-cdu.dts b/arch/arm/boot/dts/aks-cdu.dts
index 54cb5cf8604a..d9c50fbb49d2 100644
--- a/arch/arm/boot/dts/aks-cdu.dts
+++ b/arch/arm/boot/dts/aks-cdu.dts
@@ -16,6 +16,12 @@
 		bootargs = "console=ttyS0,115200 ubi.mtd=4 root=ubi0:rootfs rootfstype=ubifs";
 	};
 
+	clocks {
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+	};
+
 	ahb {
 		apb {
 			usart0: serial@fffb0000 {
-- 
1.9.1

