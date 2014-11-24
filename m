Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaKXP6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:58:47 -0500
Received: from hosting.pavoucek.net ([46.28.107.168]:60867 "EHLO
	hosting.pavoucek.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaKXP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:58:44 -0500
From: Tomas Novotny <tomas@novotny.cz>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomas Novotny <tomas@novotny.cz>
Subject: [PATCH 3/4] rtc: ds1307: add device tree bindings documentation
Date: Mon, 24 Nov 2014 16:49:23 +0100
Message-Id: <1416844164-16782-4-git-send-email-tomas@novotny.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
References: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Novotny <tomas@novotny.cz>
---
 .../devicetree/bindings/rtc/maxim,ds1307.txt       | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/maxim,ds1307.txt

diff --git a/Documentation/devicetree/bindings/rtc/maxim,ds1307.txt b/Documentation/devicetree/bindings/rtc/maxim,ds1307.txt
new file mode 100644
index 0000000..eb6164c
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/maxim,ds1307.txt
@@ -0,0 +1,23 @@
+* Maxim (Dallas) DS1307 and compatible Real Time Clock
+
+For example, compatible chips are Maxim DS1337, Microchip MCP794xx,
+STMicroelectronics M41T00 and Epson RX-8025.
+
+Required properties:
+- compatible: For example "maxim,ds1307" (see rtc-ds1307.c driver for a full
+  list).
+- reg: i2c address
+
+Example for DS1307:
+
+ds1307: rtc@68 {
+	compatible = "maxim,ds1307";
+	reg = <0x68>;
+};
+
+Example for MCP79401:
+
+mcp7940x: rtc@6f {
+	compatible = "microchip,mcp7940x";
+	reg = <0x6f>;
+};
-- 
2.1.2

