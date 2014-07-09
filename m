Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbaGIPcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:32:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48327 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932287AbaGIPH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:29 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 21/34] ARM: at91/dt: animeo_ip: define crystals frequencies
Date: Wed,  9 Jul 2014 17:06:49 +0200
Message-Id: <1404918422-7562-22-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define Somfy Animeo IP main and slow crystals frequencies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/animeo_ip.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/animeo_ip.dts b/arch/arm/boot/dts/animeo_ip.dts
index 3c4f6d983cbd..4e0ad3b82796 100644
--- a/arch/arm/boot/dts/animeo_ip.dts
+++ b/arch/arm/boot/dts/animeo_ip.dts
@@ -40,6 +40,14 @@
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

