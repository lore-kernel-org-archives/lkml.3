Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3CVP2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:28:40 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42655 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab3CVP2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:28:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/5] ARM: ux500: Supply a DTS file for the u8540 platform
Date: Fri, 22 Mar 2013 15:27:44 +0000
Message-Id: <1363966065-2478-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a skeleton DTS file which only enables serial. Just using
this simple file yields a terminal when booting u8540.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/u8540.dts |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 arch/arm/boot/dts/u8540.dts

diff --git a/arch/arm/boot/dts/u8540.dts b/arch/arm/boot/dts/u8540.dts
new file mode 100644
index 0000000..02e8e1a
--- /dev/null
+++ b/arch/arm/boot/dts/u8540.dts
@@ -0,0 +1,36 @@
+/*
+ * Copyright 2013 ST-Ericsson AB
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "dbx5x0.dtsi"
+
+/ {
+	model = "ST-Ericsson U8540 platform with Device Tree";
+	compatible = "st-ericsson,u8540";
+
+	memory {
+		reg = <0x00000000 0x20000000>;
+	};
+
+	soc-u9500 {
+		uart@80120000 {
+			status = "okay";
+		};
+
+		uart@80121000 {
+			status = "okay";
+		};
+
+		uart@80007000 {
+			status = "okay";
+		};
+	};
+};
-- 
1.7.10.4

