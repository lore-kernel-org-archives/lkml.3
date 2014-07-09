Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaGIPHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:07:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48312 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932289AbaGIPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:26 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 17/34] ARM: at91/dt: ge863-pro3: define main crystal frequency
Date: Wed,  9 Jul 2014 17:06:45 +0200
Message-Id: <1404918422-7562-18-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define Telit GE863-PRO3 main crystal frequency.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/ge863-pro3.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/ge863-pro3.dtsi b/arch/arm/boot/dts/ge863-pro3.dtsi
index 230099bb31c8..0d0e62489d93 100644
--- a/arch/arm/boot/dts/ge863-pro3.dtsi
+++ b/arch/arm/boot/dts/ge863-pro3.dtsi
@@ -19,6 +19,10 @@
 			compatible = "atmel,osc", "fixed-clock";
 			clock-frequency = <6000000>;
 		};
+
+		main_xtal {
+			clock-frequency = <6000000>;
+		};
 	};
 
 	ahb {
-- 
1.9.1

