Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaEWJKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:10:00 -0400
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:45752 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaEWJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:09:34 -0400
From: Anders Berg <anders.berg@avagotech.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH v4 5/5] ARM: dts: axxia: Add reset controller
Date: Fri, 23 May 2014 11:08:39 +0200
Message-Id: <0f4c77059d58b463781a37d66a703f1cf2d7ed96.1400834521.git.anders.berg@avagotech.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1400834521.git.anders.berg@avagotech.com>
References: <cover.1400834521.git.anders.berg@avagotech.com>
In-Reply-To: <cover.1400834521.git.anders.berg@avagotech.com>
References: <cover.1400834521.git.anders.berg@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Berg <anders.berg@lsi.com>

Add the reset controller to the AXM5xx device tree.

Signed-off-by: Anders Berg <anders.berg@lsi.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/axm55xx.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/axm55xx.dtsi b/arch/arm/boot/dts/axm55xx.dtsi
index 3fbd83c..ea288f0 100644
--- a/arch/arm/boot/dts/axm55xx.dtsi
+++ b/arch/arm/boot/dts/axm55xx.dtsi
@@ -101,6 +101,11 @@
 			reg = <0x20 0x10030000 0 0x2000>;
 		};
 
+		reset: reset@2010031000 {
+			compatible = "lsi,axm55xx-reset";
+			syscon = <&syscon>;
+		};
+
 		amba {
 			compatible = "arm,amba-bus";
 			#address-cells = <2>;
-- 
1.8.3.2

