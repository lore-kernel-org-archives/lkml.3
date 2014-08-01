Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaHACq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:46:29 -0400
Received: from exprod5og122.obsmtp.com ([64.18.0.192]:43400 "HELO
	exprod5og122.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753329AbaHACpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:45:05 -0400
From: Feng Kan <fkan@apm.com>
To: linux@roeck-us.net, dbaryshkov@gmail.com, catalin.marinas@arm.com,
        dwmw2@infradead.org, arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V9 3/6] Documentation: arm64: add SCU dts binding documentation to linux kernel
Date: Thu, 31 Jul 2014 19:45:54 -0700
Message-Id: <1406861157-29169-4-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406861157-29169-1-git-send-email-fkan@apm.com>
References: <1406861157-29169-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add documentation for the SCU system clock unit device tree binding
to the kernel.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 Documentation/devicetree/bindings/arm/apm/scu.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/apm/scu.txt

diff --git a/Documentation/devicetree/bindings/arm/apm/scu.txt b/Documentation/devicetree/bindings/arm/apm/scu.txt
new file mode 100644
index 0000000..b45be06
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/apm/scu.txt
@@ -0,0 +1,17 @@
+APM X-GENE SoC series SCU Registers
+
+This system clock unit contain various register that control block resets,
+clock enable/disables, clock divisors and other deepsleep registers.
+
+Properties:
+ - compatible : should contain two values. First value must be:
+		   - "apm,xgene-scu"
+		second value must be always "syscon".
+
+ - reg : offset and length of the register set.
+
+Example :
+	scu: system-clk-controller@17000000 {
+		compatible = "apm,xgene-scu","syscon";
+		reg = <0x0 0x17000000 0x0 0x400>;
+	};
-- 
1.9.1

