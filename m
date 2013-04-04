Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab3DDH3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:29:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42881 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177Ab3DDH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:29:13 -0400
Date: Thu, 4 Apr 2013 08:29:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: [PATCH] ARM: ux500: Supply a DTS file for the u8540 platform
Message-ID: <20130404072907.GB3004@gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
 <1364908916-29803-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdafSvT5Xb=7sqnkRHcc4UKkVzr8jzThMgWn6459RDmKGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdafSvT5Xb=7sqnkRHcc4UKkVzr8jzThMgWn6459RDmKGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a skeleton DTS file which only enables serial. Just using
this simple file yields a terminal when booting u8540.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ccu8540.dts |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 arch/arm/boot/dts/ccu8540.dts

diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
new file mode 100644
index 0000000..02e8e1a
--- /dev/null
+++ b/arch/arm/boot/dts/ccu8540.dts
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
+  model = "ST-Ericsson U8540 platform with Device Tree";
+  compatible = "st-ericsson,u8540";
+
+	memory {
+	       reg = <0x00000000 0x20000000>;
+	       };
+
+	soc-u9500 {
+		  uart@80120000 {
+					status = "okay";
+					       };
+
+		uart@80121000 {
+				status = "okay";
+				       };
+
+		uart@80007000 {
+				status = "okay";
+				       };
+				       };
+};
-- 
1.7.10.4
