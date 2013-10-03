Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3JCO4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:56:20 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:42476 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab3JCO4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:56:18 -0400
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
Subject: [PATCH 1/2] ARM: DT: msm: Add Qualcomm's PRNG driver binding document
Date: Thu,  3 Oct 2013 17:52:34 +0300
Message-Id: <1380811955-18085-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com>
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com>
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
index 000000000000..92be00085ab1
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
+- clock-names : "prng" clocks all registers, FIFO and circuits in PRNG IP block
+
+Example:
+
+	rng {
+		compatible = "qcom,prng";
+		reg = <0xf9bff000 0x200>;
+		clocks = <&clock GCC_PRNG_AHB_CLK>;
+		clock-names = "prng";
+	};
-- 
1.8.3.1

