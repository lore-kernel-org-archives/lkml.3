Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaGIPH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:07:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48330 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932287AbaGIPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:26 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Joachim Eastwood <manabian@gmail.com>
Subject: [PATCHv3 16/34] ARM: at91/dt: mpa1600: define crytals frequencies
Date: Wed,  9 Jul 2014 17:06:44 +0200
Message-Id: <1404918422-7562-17-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define Phontech MPA 1600 main and slow crystals frequencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Joachim Eastwood <manabian@gmail.com>
---
 arch/arm/boot/dts/mpa1600.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/mpa1600.dts b/arch/arm/boot/dts/mpa1600.dts
index ccf9ea242f72..f0f5e1098928 100644
--- a/arch/arm/boot/dts/mpa1600.dts
+++ b/arch/arm/boot/dts/mpa1600.dts
@@ -25,6 +25,14 @@
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

