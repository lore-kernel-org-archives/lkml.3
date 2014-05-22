Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaEVNuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:50:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57529 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaEVNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:50:05 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <arnd@arndb.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v5 3/7] mfd: ti-keystone-devctrl: add bindings for device state control
Date: Thu, 22 May 2014 16:48:32 +0300
Message-ID: <1400766516-14537-4-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400766516-14537-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400766516-14537-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Keystone II devices have a set of registers that are used to control
the status of its peripherals. This node is intended to allow access to
this functionality.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../devicetree/bindings/mfd/ti-keystone-devctrl.txt   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt

diff --git a/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt b/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
new file mode 100644
index 0000000..35f7a66
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
@@ -0,0 +1,19 @@
+* Device tree bindings for Texas Instruments keystone device state control
+
+The Keystone II devices have a set of registers that are used to control
+the status of its peripherals. This node is intended to allow access to
+this functionality.
+
+Required properties:
+
+- compatible:		"ti,keystone-devctrl", "syscon"
+
+- reg:			contains offset/length value for pll controller
+			registers space.
+
+Example:
+
+devctrl: device-state-control {
+	compatible = "ti,keystone-devctrl", "syscon";
+	reg = <0x02620000 0x1000>;
+};
-- 
1.8.3.2

