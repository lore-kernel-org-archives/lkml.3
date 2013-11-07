Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3KGNzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:55:39 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:53872 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3KGNzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:55:22 -0500
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH v3 2/2] ARC: Add documentation on DT binding for ARC700 PMU
Date: Thu,  7 Nov 2013 14:55:12 +0100
Message-Id: <1383832512-21130-3-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
References: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 Documentation/devicetree/bindings/arc/pmu.txt |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arc/pmu.txt

diff --git a/Documentation/devicetree/bindings/arc/pmu.txt b/Documentation/devicetree/bindings/arc/pmu.txt
new file mode 100644
index 0000000..49d5173
--- /dev/null
+++ b/Documentation/devicetree/bindings/arc/pmu.txt
@@ -0,0 +1,24 @@
+* ARC Performance Monitor Unit
+
+The ARC 700 can be configured with a pipeline performance monitor for counting
+CPU and cache events like cache misses and hits.
+
+Note that:
+ * ARC 700 refers to a family of ARC processor cores;
+   - There is only one type of PMU available for the whole family;
+   - The PMU may support different sets of events; supported events are probed
+     at boot time, as required by the reference manual.
+
+ * The ARC 700 PMU does not support interrupts; although HW events may be
+   counted, the HW events themselves cannot serve as a trigger for a sample.
+
+Required properties:
+
+- compatible : should contain
+	"snps,arc700-pmu"
+
+Example:
+
+pmu {
+        compatible = "snps,arc700-pmu";
+};
-- 
1.7.9.5

