Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaKNAUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:20:12 -0500
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:60686 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754364AbaKNAUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:20:04 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, =devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V2 2/7] Documentation: arm64: add SCU dts binding documentation to linux kernel
Date: Thu, 13 Nov 2014 16:19:56 -0800
Message-Id: <1415924401-3013-3-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415924401-3013-1-git-send-email-fkan@apm.com>
References: <1415924401-3013-1-git-send-email-fkan@apm.com>
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

