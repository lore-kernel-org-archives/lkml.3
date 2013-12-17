Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3LQTiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:38:46 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:53828 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab3LQTik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:38:40 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH v3 03/21] ARM: dts: fix pxa27x-gpio interrupts
Date: Tue, 17 Dec 2013 23:37:33 +0400
Message-Id: <1387309071-22382-4-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
   v2..v3
   v1..v2
   * no changes

 arch/arm/boot/dts/pxa27x.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/pxa27x.dtsi b/arch/arm/boot/dts/pxa27x.dtsi
index d7c5d72..44df554 100644
--- a/arch/arm/boot/dts/pxa27x.dtsi
+++ b/arch/arm/boot/dts/pxa27x.dtsi
@@ -10,5 +10,11 @@
 			marvell,intc-priority;
 			marvell,intc-nr-irqs = <34>;
 		};
+
+		gpio: gpio@40e00000 {
+			compatible = "intel,pxa27x-gpio";
+			interrupts = <8>, <9>, <10>;
+			interrupt-names = "gpio0", "gpio1", "gpio_mux";
+		};
 	};
 };
-- 
1.8.4.2

