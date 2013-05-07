Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3EGNC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:02:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39525 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3EGNC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:02:56 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH V3 17/21] ARM: dts: thermal: exynos4: Add documentation for Exynos SoC thermal bindings
Date: Tue,  7 May 2013 18:31:07 +0530
Message-Id: <1367931671-3906-18-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukasz Majewski <l.majewski@samsung.com>

Proper description for Exynos4 bindings added to Documentation/devicetree/
bindings

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/thermal/exynos-thermal.txt |   25 ++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/exynos-thermal.txt

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
new file mode 100644
index 0000000..535fd0e
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -0,0 +1,25 @@
+* Exynos Thermal Management Unit (TMU)
+
+** Required properties:
+
+- compatible : One of the following:
+	       "samsung,exynos4412-tmu"
+	       "samsung,exynos4210-tmu"
+	       "samsung,exynos5250-tmu"
+- interrupt-parent : The phandle for the interrupt controller
+- reg : Address range of the thermal registers
+- interrupts : Should contain interrupt for thermal system
+- clocks : The main clock for TMU device
+- clock-names : Thermal system clock name
+
+Example:
+
+	tmu@100C0000 {
+		compatible = "samsung,exynos4412-tmu";
+		interrupt-parent = <&combiner>;
+		reg = <0x100C0000 0x100>;
+		interrupts = <2 4>;
+		clocks = <&clock 383>;
+		clock-names = "tmu_apbif";
+		status = "disabled";
+	};
-- 
1.7.1

