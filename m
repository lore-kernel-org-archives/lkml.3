Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab3JOOOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:14:37 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:55549 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3JOOOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:14:35 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 1/2] ARM: DT: msm: Add Qualcomm's PRNG driver binding document
Date: Tue, 15 Oct 2013 17:11:17 +0300
Message-Id: <1381846278-9529-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Qualcomm PRNG driver device tree binding documentation
to use as an example in dts trees.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 Documentation/devicetree/bindings/rng/qcom,prng.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/qcom,prng.txt

diff --git a/Documentation/devicetree/bindings/rng/qcom,prng.txt b/Documentation/devicetree/bindings/rng/qcom,prng.txt
new file mode 100644
index 000000000000..8e5853c2879b
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/qcom,prng.txt
@@ -0,0 +1,17 @@
+Qualcomm MSM pseudo random number generator.
+
+Required properties:
+
+- compatible  : should be "qcom,prng"
+- reg         : specifies base physical address and size of the registers map
+- clocks      : phandle to clock-controller plus clock-specifier pair
+- clock-names : "core" clocks all registers, FIFO and circuits in PRNG IP block
+
+Example:
+
+	rng@f9bff000 {
+		compatible = "qcom,prng";
+		reg = <0xf9bff000 0x200>;
+		clocks = <&clock GCC_PRNG_AHB_CLK>;
+		clock-names = "core";
+	};
-- 
1.8.3.1

