Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaI2AYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:24:10 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:48073 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaI2AXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:23:54 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] ARM: meson: documentation: Add timer documentation
Date: Mon, 29 Sep 2014 02:23:37 +0200
Message-Id: <1411950226-21598-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
References: <5428A559.5050908@linaro.org>
 <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlo Caione <carlo@caione.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Carlo Caione <carlo@caione.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../devicetree/bindings/timer/amlogic,meson6-timer.txt    | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt b/Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt
new file mode 100644
index 0000000..a092053
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt
@@ -0,0 +1,15 @@
+Amlogic Meson6 SoCs Timer Controller
+
+Required properties:
+
+- compatible : should be "amlogic,meson6-timer"
+- reg : Specifies base physical address and size of the registers.
+- interrupts : The interrupt of the first timer
+
+Example:
+
+timer@c1109940 {
+	compatible = "amlogic,meson6-timer";
+	reg = <0xc1109940 0x14>;
+	interrupts = <0 10 1>;
+};
-- 
1.9.1

